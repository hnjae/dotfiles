-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2026 KIM Hyunjae

-- A goal that survives turns: /goal starts it, TurnEnd continues it, and a
-- reviewer audits a completion claim before the goal is accepted.

local State = require("plugins.goal.state")
local Prompt = require("plugins.goal.prompt")
local Transcript = require("plugins.goal.transcript")

local MAX_ROUNDS = 50
local MAX_STALLS = 3
local MAX_JUDGE_ATTEMPTS = 2
local MAX_AUDIT_OPENS = 2
local AUDIT_RETRY_MS = 250
local MAX_TRANSCRIPT_CHARS = 40000
local MAX_TOOL_RESULT_CHARS = 2000

local LIMITS = { rounds = MAX_ROUNDS, stalls = MAX_STALLS }
local JUDGE_RETRY =
  'Your previous reply was not valid JSON. Reply with exactly one line: {"approved":true|false,"reason":"..."}'

local pending = {}
local running = {}
local turn_tools = {}
local auditing = {}
local id_counter = 0

local function new_id(prefix)
  id_counter = id_counter + 1
  return string.format("%s-%d-%d", prefix, os.time(), id_counter)
end

local function log_warn(message)
  maki.log.warn("goal: " .. tostring(message))
end

local function state_dir()
  local ok, dir = pcall(maki.env.state_dir)
  if not ok then
    dir = nil
  end
  return State.resolve_state_dir(dir, os.getenv)
end

local function goal_path(session_id)
  local dir, err = state_dir()
  if not dir then
    return nil, err
  end
  return State.state_path(dir, session_id)
end

local function read_document(session_id)
  local path, path_err = goal_path(session_id)
  if not path then
    return nil, path_err
  end
  local metadata, metadata_err = maki.fs.metadata(path)
  if metadata_err then
    return nil, "cannot inspect goal state: " .. tostring(metadata_err)
  end
  if not metadata then
    return { path = path }
  end
  local content, read_err = maki.fs.read(path)
  if not content then
    return nil, "cannot read goal state: " .. tostring(read_err)
  end
  local document, decode_err =
    maki.json.decode(content, { luanil = { object = true, array = true } })
  if not document then
    return nil, "cannot decode goal state: " .. tostring(decode_err)
  end
  local valid, validation_err = State.validate_document(document, session_id)
  if not valid then
    return nil, validation_err
  end
  return { document = document, path = path }
end

local function read_goal(session_id)
  local state, state_err = read_document(session_id)
  if not state then
    return nil, state_err
  end
  return state.document and state.document.goal or nil, nil, state.path
end

local function write_goal(path, session_id, record)
  local document = { version = 1, session_id = session_id, goal = record }
  local valid, validation_err = State.validate_document(document, session_id)
  if not valid then
    return nil, validation_err
  end
  local encoded, encode_err = maki.json.encode(document)
  if not encoded then
    return nil, "cannot encode goal state: " .. tostring(encode_err)
  end
  local created, mkdir_err = maki.fs.mkdir(maki.fs.dirname(path), { parents = true })
  if not created then
    return nil, "cannot create goal state directory: " .. tostring(mkdir_err)
  end
  local written, write_err = maki.fs.atomic_write(path, encoded)
  if not written then
    return nil, "cannot write goal state: " .. tostring(write_err)
  end
  return true
end

-- Normalize a state left behind by an interrupted audit. Commands use this;
-- read-only paths and tool calls use read_goal so an audit in progress is
-- not cancelled by a status check.
local function load_goal(session_id)
  local record, read_err, path = read_goal(session_id)
  if not record then
    return record, read_err, path
  end
  if record.status ~= "auditing" then
    return record, nil, path
  end
  local paused, pause_err =
    State.force_pause(record, "completion audit was interrupted; /goal resume", os.time())
  if not paused then
    return nil, pause_err, path
  end
  local written, write_err = write_goal(path, session_id, paused)
  if not written then
    return nil, write_err, path
  end
  return paused, nil, path
end

local function interrupted(session_id, record)
  return record ~= nil
    and record.status == "active"
    and pending[session_id] == nil
    and running[session_id] == nil
end

local function refresh_hint(session_id)
  local record, err = read_goal(session_id)
  if err then
    maki.ui.set_status_hint(nil, { session = session_id })
    return
  end
  local text = State.hint(record, interrupted(session_id, record), MAX_ROUNDS)
  maki.ui.set_status_hint(text and { { text, "" } } or nil, { session = session_id })
end

local function clear_fences(session_id)
  pending[session_id] = nil
  running[session_id] = nil
  turn_tools[session_id] = nil
  auditing[session_id] = nil
end

local function deliver(session_id, path, record, text)
  pending[session_id] = { execution_id = record.execution_id, goal_id = record.id }
  local ok, delivered, delivery_err = pcall(maki.session.notify, text, {
    session = session_id,
    wake = true,
  })
  if not ok then
    delivered, delivery_err = nil, delivered
  end
  if delivered then
    return true
  end
  pending[session_id] = nil
  if record.status == "active" then
    local blocked = State.request_blocked(
      record,
      record.id,
      record.execution_id,
      "goal delivery failed: " .. tostring(delivery_err),
      os.time()
    )
    if blocked then
      write_goal(path, session_id, blocked)
    end
  end
  return nil, delivery_err
end

local function focused_session()
  local session_id, err = maki.session.current()
  if not session_id then
    return nil, err
  end
  return session_id
end

local function finish_command(session_id, record, message)
  refresh_hint(session_id)
  maki.ui.flash(message or State.format(record, interrupted(session_id, record), MAX_ROUNDS))
end

local function start_goal(objective)
  local session_id, session_err = focused_session()
  if not session_id then
    return nil, session_err
  end
  local existing, read_err = load_goal(session_id)
  if read_err then
    return nil, read_err
  end
  if existing and existing.status ~= "complete" then
    return nil, "a goal already exists (" .. existing.status .. "); use /goal clear first"
  end
  local path, path_err = goal_path(session_id)
  if not path then
    return nil, path_err
  end
  local record = State.new_goal(new_id("goal"), new_id("exec"), objective, os.time())
  local written, write_err = write_goal(path, session_id, record)
  if not written then
    return nil, write_err
  end
  local delivered, delivery_err = deliver(session_id, path, record, Prompt.kickoff(record))
  if not delivered then
    return nil, delivery_err
  end
  return record, nil, session_id
end

local function pause_goal()
  local session_id, session_err = focused_session()
  if not session_id then
    return nil, session_err
  end
  local record, read_err, path = read_goal(session_id)
  if not record then
    return nil, read_err or "no goal is set for this session"
  end
  local paused, pause_err = State.pause(record, os.time())
  if not paused then
    return nil, pause_err
  end
  local written, write_err = write_goal(path, session_id, paused)
  if not written then
    return nil, write_err
  end
  clear_fences(session_id)
  return paused, nil, session_id
end

local function resume_goal()
  local session_id, session_err = focused_session()
  if not session_id then
    return nil, session_err
  end
  local record, read_err, path = load_goal(session_id)
  if not record then
    return nil, read_err or "no goal is set for this session"
  end
  if record.status == "active" and (pending[session_id] or running[session_id]) then
    return nil, "the goal is already running"
  end
  local resumed, resume_err = State.resume(record, new_id("exec"), os.time())
  if not resumed then
    return nil, resume_err
  end
  local written, write_err = write_goal(path, session_id, resumed)
  if not written then
    return nil, write_err
  end
  local delivered, delivery_err = deliver(session_id, path, resumed, Prompt.continuation(resumed))
  if not delivered then
    return nil, delivery_err
  end
  return resumed, nil, session_id
end

local function clear_goal()
  local session_id, session_err = focused_session()
  if not session_id then
    return nil, session_err
  end
  local path, path_err = goal_path(session_id)
  if not path then
    return nil, path_err
  end
  local removed, remove_err = maki.fs.rm(path, { force = true })
  if not removed then
    return nil, "cannot delete goal state: " .. tostring(remove_err)
  end
  clear_fences(session_id)
  maki.ui.set_status_hint(nil, { session = session_id })
  return true, nil, session_id
end

local function command(opts)
  local arg = (opts.args or ""):gsub("^%s+", ""):gsub("%s+$", "")
  local session_id
  local record, err
  if arg == "" then
    session_id, err = focused_session()
    if session_id then
      record, err = load_goal(session_id)
    end
  elseif arg == "pause" then
    record, err, session_id = pause_goal()
  elseif arg == "resume" then
    record, err, session_id = resume_goal()
  elseif arg == "clear" then
    local cleared
    cleared, err, session_id = clear_goal()
    if cleared then
      maki.ui.flash("Goal cleared.")
      return
    end
  else
    record, err, session_id = start_goal(arg)
  end
  if err then
    if session_id then
      refresh_hint(session_id)
    end
    maki.ui.flash("Goal error: " .. tostring(err))
    return
  end
  if session_id then
    finish_command(session_id, record)
  end
end

maki.api.register_command({
  name = "/goal",
  description = "Set, inspect, pause, resume, or clear a session goal.",
  nargs = "*",
  handler = command,
})

maki.api.register_prompt_hint({
  slot = "tool_usage",
  content = "- Use goal_get to inspect the active goal and goal_update to mark it complete or blocked.",
})

maki.api.register_tool({
  name = "goal_get",
  description = "Read the current session's goal and progress.",
  kind = "read",
  audiences = { "main" },
  schema = {
    type = "object",
    properties = {},
    additionalProperties = false,
  },
  handler = function(_, ctx)
    local session_id, session_err = ctx:session_id()
    if not session_id then
      return { llm_output = tostring(session_err or "this run has no session"), is_error = true }
    end
    local record, read_err = read_goal(session_id)
    if read_err then
      return { llm_output = read_err, is_error = true }
    end
    return State.format(record, interrupted(session_id, record), MAX_ROUNDS)
  end,
})

maki.api.register_tool({
  name = "goal_update",
  description = "Mark the active goal complete (runs a completion audit) or blocked.",
  kind = "execute",
  audiences = { "main" },
  schema = {
    type = "object",
    properties = {
      goal_id = { type = "string" },
      execution_id = { type = "string" },
      status = { type = "string", enum = { "complete", "blocked" } },
      summary = { type = "string" },
    },
    required = { "goal_id", "execution_id", "status", "summary" },
    additionalProperties = false,
  },
  handler = function(input, ctx)
    local session_id, session_err = ctx:session_id()
    if not session_id then
      return { llm_output = tostring(session_err or "this run has no session"), is_error = true }
    end
    local record, read_err, path = read_goal(session_id)
    if not record then
      return { llm_output = read_err or "no goal is set for this session", is_error = true }
    end
    local updated, update_err
    if input.status == "complete" then
      updated, update_err =
        State.request_complete(record, input.goal_id, input.execution_id, input.summary, os.time())
    else
      updated, update_err =
        State.request_blocked(record, input.goal_id, input.execution_id, input.summary, os.time())
    end
    if not updated then
      return { llm_output = update_err, is_error = true }
    end
    local written, write_err = write_goal(path, session_id, updated)
    if not written then
      return { llm_output = write_err, is_error = true }
    end
    refresh_hint(session_id)
    if input.status == "complete" then
      return "Completion recorded. The completion audit runs at the end of this turn; keep the goal active until it returns."
    end
    return "Goal marked blocked."
  end,
})

local function parse_verdict(text)
  if type(text) ~= "string" then
    return nil
  end
  local candidates = { text:match("^%s*(.-)%s*$"), text:match("(%b{})") }
  for _, candidate in ipairs(candidates) do
    if candidate and candidate ~= "" then
      local decoded = maki.json.decode(candidate)
      if
        type(decoded) == "table"
        and type(decoded.approved) == "boolean"
        and type(decoded.reason) == "string"
        and decoded.reason:match("%S")
      then
        return decoded
      end
    end
  end
  return nil
end

local function audit_error(session_id, expected, message)
  local record, read_err, path = read_goal(session_id)
  if not record then
    if read_err then
      log_warn("audit cleanup: " .. read_err)
    end
    return
  end
  if
    record.status ~= "auditing" or not State.matches(record, expected.id, expected.execution_id)
  then
    return
  end
  local paused, pause_err = State.force_pause(record, message, os.time())
  if not paused then
    log_warn("audit cleanup: " .. tostring(pause_err))
    return
  end
  local written, write_err = write_goal(path, session_id, paused)
  if not written then
    log_warn("audit cleanup: " .. tostring(write_err))
    return
  end
  refresh_hint(session_id)
  maki.notify("goal paused: " .. message, "warn", { title = "goal" })
end

local function run_audit(session_id, record, path)
  if auditing[session_id] then
    return
  end
  auditing[session_id] = true
  local ok, audit_err = pcall(function()
    local messages, messages_err = maki.session.messages({ session = session_id })
    if not messages then
      error("cannot read transcript: " .. tostring(messages_err), 0)
    end
    local transcript = Transcript.render(messages, {
      encode = maki.json.encode,
      max_chars = MAX_TRANSCRIPT_CHARS,
      max_tool_chars = MAX_TOOL_RESULT_CHARS,
    })
    local auditor, auditor_err
    for attempt = 1, MAX_AUDIT_OPENS do
      auditor, auditor_err = maki.agent.session({
        session = session_id,
        scope = "session",
        name = "goal-auditor",
        system = Prompt.judge_system(),
        thinking = "off",
      })
      if auditor then
        break
      end
      if attempt < MAX_AUDIT_OPENS then
        maki.log.info("goal: auditor open failed, retrying: " .. tostring(auditor_err))
        maki.async.sleep(AUDIT_RETRY_MS)
      end
    end
    if not auditor then
      error("cannot open auditor: " .. tostring(auditor_err), 0)
    end
    local verdict
    local prompt = Prompt.judge_user(record, transcript)
    local result, prompt_err
    for _ = 1, MAX_JUDGE_ATTEMPTS do
      local prompt_ok, prompted, prompt_error = pcall(auditor.prompt, auditor, prompt)
      if not prompt_ok then
        result, prompt_err = nil, prompted
        break
      end
      result, prompt_err = prompted, prompt_error
      if not result then
        break
      end
      verdict = parse_verdict(result.text)
      if verdict then
        break
      end
      prompt = JUDGE_RETRY
    end
    auditor:close()
    if not result then
      error("auditor failed: " .. tostring(prompt_err), 0)
    end
    if not verdict then
      audit_error(session_id, record, "the auditor returned no usable verdict")
      return
    end

    local latest, latest_err, latest_path = read_goal(session_id)
    if not latest then
      if latest_err then
        error(latest_err, 0)
      end
      return
    end
    if
      latest.id ~= record.id
      or latest.execution_id ~= record.execution_id
      or latest.status ~= "auditing"
    then
      return
    end
    local updated, update_err
    if verdict.approved then
      updated, update_err = State.audit_approved(latest, latest.id, latest.execution_id, os.time())
    else
      updated, update_err =
        State.audit_rejected(latest, latest.id, latest.execution_id, verdict.reason, os.time())
    end
    if not updated then
      error(update_err, 0)
    end
    local written, write_err = write_goal(latest_path, session_id, updated)
    if not written then
      error(write_err, 0)
    end
    refresh_hint(session_id)
    if verdict.approved then
      maki.notify("goal complete: " .. verdict.reason, "info", { title = "goal" })
    else
      local delivered, delivery_err =
        deliver(session_id, latest_path, updated, Prompt.continuation(updated, verdict.reason))
      if not delivered then
        error("audit feedback delivery failed: " .. tostring(delivery_err), 0)
      end
    end
  end)
  auditing[session_id] = nil
  if not ok then
    log_warn("audit [session " .. session_id .. "]: " .. tostring(audit_err))
    audit_error(session_id, record, "the completion audit failed: " .. tostring(audit_err))
  end
end

maki.api.create_autocmd("TurnStart", {
  callback = function(event)
    local session_id = event.data.session_id
    local fence = pending[session_id]
    pending[session_id] = nil
    running[session_id] = fence
    turn_tools[session_id] = false
    refresh_hint(session_id)
  end,
})

maki.api.create_autocmd("ToolStart", {
  callback = function(event)
    local session_id = event.data.session_id
    if not running[session_id] then
      return
    end
    local tool = event.data.tool
    if tool ~= "goal_get" and tool ~= "goal_update" then
      turn_tools[session_id] = true
    end
  end,
})

maki.api.create_autocmd("TurnEnd", {
  callback = function(event)
    local session_id = event.data.session_id
    local fence = running[session_id]
    running[session_id] = nil
    local tools_used = turn_tools[session_id] == true
    turn_tools[session_id] = nil
    local reason = event.data.reason

    maki.async.run(function()
      local ok, err = pcall(function()
        local record, read_err, path = read_goal(session_id)
        if not record then
          if read_err then
            log_warn(read_err)
          end
          refresh_hint(session_id)
          return
        end
        if reason == "cancelled" or reason == "dropped" then
          if record.status == "auditing" and fence then
            audit_error(session_id, record, "the turn was cancelled during the completion audit")
          end
          refresh_hint(session_id)
          return
        end
        if record.status == "auditing" then
          run_audit(session_id, record, path)
          return
        end
        if not fence then
          refresh_hint(session_id)
          return
        end
        local next_record, decision =
          State.after_turn(record, fence.execution_id, tools_used, LIMITS, os.time())
        if not next_record then
          refresh_hint(session_id)
          return
        end
        local written, write_err = write_goal(path, session_id, next_record)
        if not written then
          error(write_err, 0)
        end
        if decision == "paused" then
          refresh_hint(session_id)
          maki.notify(
            "goal paused: " .. tostring(next_record.audit_reason),
            "warn",
            { title = "goal" }
          )
          return
        end
        local delivered, delivery_err = deliver(
          session_id,
          path,
          next_record,
          Prompt.continuation(next_record, next_record.audit_reason)
        )
        if not delivered then
          error("continuation delivery failed: " .. tostring(delivery_err), 0)
        end
      end)
      if not ok then
        log_warn("turn end [session " .. session_id .. "]: " .. tostring(err))
        refresh_hint(session_id)
      end
    end)
  end,
})

maki.api.create_autocmd("TurnError", {
  callback = function(event)
    local session_id = event.data.session_id
    local fence = running[session_id]
    running[session_id] = nil
    turn_tools[session_id] = nil
    maki.async.run(function()
      local ok, err = pcall(function()
        local record, read_err, path = read_goal(session_id)
        if not record then
          if read_err then
            log_warn(read_err)
          end
          refresh_hint(session_id)
          return
        end
        local updated, update_err
        if record.status == "auditing" and fence then
          updated, update_err = State.force_pause(
            record,
            "turn failed during the completion audit: " .. tostring(event.data.message),
            os.time()
          )
        elseif
          fence
          and record.status == "active"
          and record.execution_id == fence.execution_id
        then
          updated, update_err = State.request_blocked(
            record,
            record.id,
            record.execution_id,
            "turn failed: " .. tostring(event.data.message),
            os.time()
          )
        else
          refresh_hint(session_id)
          return
        end
        if not updated then
          error(update_err, 0)
        end
        local written, write_err = write_goal(path, session_id, updated)
        if not written then
          error(write_err, 0)
        end
        refresh_hint(session_id)
        maki.notify("goal blocked after a turn error", "warn", { title = "goal" })
      end)
      if not ok then
        log_warn("turn error [session " .. session_id .. "]: " .. tostring(err))
        refresh_hint(session_id)
      end
    end)
  end,
})

maki.api.create_autocmd({ "SessionReset", "SessionEnd" }, {
  callback = function(event)
    local session_id = event.data.session_id
    clear_fences(session_id)
    maki.ui.set_status_hint(nil, { session = session_id })
  end,
})
