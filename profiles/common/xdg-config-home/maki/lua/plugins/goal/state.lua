-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2026 KIM Hyunjae

-- Pure goal state machine. No `maki` access, so the transitions can be
-- exercised with a plain Lua interpreter.

local M = {}

local STATUSES = {
  active = true,
  auditing = true,
  blocked = true,
  complete = true,
  paused = true,
}

local DOCUMENT_KEYS = { goal = true, session_id = true, version = true }
local GOAL_KEYS = {
  audit_reason = true,
  created_at = true,
  execution_id = true,
  id = true,
  objective = true,
  rounds = true,
  stalls = true,
  status = true,
  summary = true,
  updated_at = true,
}
local MAX_SESSION_ID_BYTES = 128

local function non_empty(value)
  return type(value) == "string" and value:match("%S") ~= nil
end

local function integer(value)
  return type(value) == "number" and value == math.floor(value)
end

local function copy(record)
  local out = {}
  for key, value in pairs(record) do
    out[key] = value
  end
  return out
end

local function exact_keys(value, allowed, label)
  for key in pairs(value) do
    if type(key) ~= "string" or not allowed[key] then
      return nil, label .. " contains unknown field " .. tostring(key)
    end
  end
  return true
end

function M.joinpath(left, right)
  if left:sub(-1) == "/" then
    return left .. right
  end
  return left .. "/" .. right
end

-- Prefer the directory maki reports. Fall back to the XDG variable and then
-- to the conventional path, so a plugin still finds its state when the host
-- cannot resolve a state directory.
function M.resolve_state_dir(env_state_dir, getenv)
  if non_empty(env_state_dir) then
    return env_state_dir
  end
  local xdg = getenv and getenv("XDG_STATE_HOME")
  if non_empty(xdg) then
    return M.joinpath(xdg, "maki")
  end
  local home = getenv and getenv("HOME")
  if non_empty(home) then
    return M.joinpath(home, ".local/state/maki")
  end
  return nil,
    "cannot resolve state directory (maki.env.state_dir, XDG_STATE_HOME and HOME are empty)"
end

function M.session_filename(session_id)
  if not non_empty(session_id) or #session_id > MAX_SESSION_ID_BYTES then
    return nil, "goal session id must be a non-empty string of at most 128 bytes"
  end
  if not session_id:match("^[A-Za-z0-9_-]+$") then
    return nil, "goal session id contains unsafe filename characters"
  end
  return session_id .. ".json"
end

function M.state_path(state_dir, session_id)
  if not non_empty(state_dir) then
    return nil, "goal state directory is empty"
  end
  local filename, err = M.session_filename(session_id)
  if not filename then
    return nil, err
  end
  return M.joinpath(M.joinpath(state_dir, "local.goal"), filename)
end

function M.new_goal(id, execution_id, objective, now)
  return {
    created_at = now,
    execution_id = execution_id,
    id = id,
    objective = objective,
    rounds = 0,
    stalls = 0,
    status = "active",
    updated_at = now,
  }
end

function M.validate_record(record)
  if type(record) ~= "table" then
    return nil, "goal record must be an object"
  end
  local keys_ok, keys_err = exact_keys(record, GOAL_KEYS, "goal record")
  if not keys_ok then
    return nil, keys_err
  end
  if not non_empty(record.id) then
    return nil, "goal id must be a non-empty string"
  end
  if not non_empty(record.execution_id) then
    return nil, "goal execution id must be a non-empty string"
  end
  if not non_empty(record.objective) then
    return nil, "goal objective must be a non-empty string"
  end
  if not STATUSES[record.status] then
    return nil, "goal status is invalid"
  end
  if not integer(record.rounds) or record.rounds < 0 then
    return nil, "goal rounds must be a non-negative integer"
  end
  if not integer(record.stalls) or record.stalls < 0 then
    return nil, "goal stalls must be a non-negative integer"
  end
  if not integer(record.created_at) or record.created_at < 0 then
    return nil, "goal created_at must be a non-negative integer"
  end
  if not integer(record.updated_at) or record.updated_at < 0 then
    return nil, "goal updated_at must be a non-negative integer"
  end
  if record.audit_reason ~= nil and not non_empty(record.audit_reason) then
    return nil, "goal audit_reason must be absent or non-empty"
  end
  if record.status == "active" then
    if record.summary ~= nil then
      return nil, "active goal cannot have a summary"
    end
  elseif
    record.status == "auditing"
    or record.status == "blocked"
    or record.status == "complete"
  then
    if not non_empty(record.summary) then
      return nil, record.status .. " goal must have a non-empty summary"
    end
  elseif record.summary ~= nil and not non_empty(record.summary) then
    return nil, "paused goal summary must be absent or non-empty"
  end
  return true
end

function M.validate_document(document, session_id)
  if type(document) ~= "table" or document.version ~= 1 then
    return nil, "goal state must be a version 1 session document"
  end
  local keys_ok, keys_err = exact_keys(document, DOCUMENT_KEYS, "goal document")
  if not keys_ok then
    return nil, keys_err
  end
  if document.session_id ~= session_id then
    return nil, "goal state session id does not match its filename"
  end
  local goal_ok, goal_err = M.validate_record(document.goal)
  if not goal_ok then
    return nil, "invalid goal for session " .. tostring(session_id) .. ": " .. goal_err
  end
  return true
end

function M.matches(record, goal_id, execution_id)
  return record ~= nil and record.id == goal_id and record.execution_id == execution_id
end

function M.pause(record, now)
  if record.status == "complete" then
    return nil, "a complete goal cannot be paused"
  end
  if record.status == "paused" then
    return nil, "the goal is already paused"
  end
  local paused = copy(record)
  paused.status = "paused"
  paused.summary = nil
  paused.audit_reason = nil
  paused.updated_at = now
  return paused
end

function M.resume(record, execution_id, now)
  if record.status == "complete" then
    return nil, "a complete goal cannot be resumed"
  end
  if record.status == "auditing" then
    return nil, "the goal is being audited; wait or pause it first"
  end
  local resumed = copy(record)
  resumed.execution_id = execution_id
  resumed.status = "active"
  resumed.rounds = 0
  resumed.stalls = 0
  resumed.summary = nil
  resumed.audit_reason = nil
  resumed.updated_at = now
  return resumed
end

function M.request_complete(record, goal_id, execution_id, summary, now)
  if record.status ~= "active" then
    return nil, "only an active goal can be completed (current: " .. tostring(record.status) .. ")"
  end
  if not M.matches(record, goal_id, execution_id) then
    return nil, "goal or execution id is stale; call goal_get for the current goal"
  end
  if not non_empty(summary) then
    return nil, "a completion summary is required"
  end
  local auditing = copy(record)
  auditing.status = "auditing"
  auditing.summary = summary
  auditing.audit_reason = nil
  auditing.updated_at = now
  return auditing
end

function M.request_blocked(record, goal_id, execution_id, summary, now)
  if record.status ~= "active" then
    return nil, "only an active goal can be blocked (current: " .. tostring(record.status) .. ")"
  end
  if not M.matches(record, goal_id, execution_id) then
    return nil, "goal or execution id is stale; call goal_get for the current goal"
  end
  if not non_empty(summary) then
    return nil, "a blocked summary is required"
  end
  local blocked = copy(record)
  blocked.status = "blocked"
  blocked.summary = summary
  blocked.audit_reason = nil
  blocked.updated_at = now
  return blocked
end

function M.audit_approved(record, goal_id, execution_id, now)
  if record.status ~= "auditing" then
    return nil, "the goal is not being audited"
  end
  if not M.matches(record, goal_id, execution_id) then
    return nil, "goal or execution id is stale"
  end
  local complete = copy(record)
  complete.status = "complete"
  complete.audit_reason = nil
  complete.updated_at = now
  return complete
end

function M.audit_rejected(record, goal_id, execution_id, reason, now)
  if record.status ~= "auditing" then
    return nil, "the goal is not being audited"
  end
  if not M.matches(record, goal_id, execution_id) then
    return nil, "goal or execution id is stale"
  end
  if not non_empty(reason) then
    reason = "the completion audit found the goal unfinished"
  end
  local active = copy(record)
  active.status = "active"
  active.summary = nil
  active.audit_reason = reason
  active.updated_at = now
  return active
end

function M.force_pause(record, reason, now)
  if record.status == "complete" then
    return nil, "a complete goal cannot be paused"
  end
  local paused = copy(record)
  paused.status = "paused"
  paused.summary = nil
  paused.audit_reason = reason
  paused.updated_at = now
  return paused
end

-- Decide what a finished goal turn means. Returns the next record and
-- "continue" or "paused", or nil when the turn did not belong to this goal.
function M.after_turn(record, execution_id, tools_used, limits, now)
  if record.status ~= "active" or record.execution_id ~= execution_id then
    return nil, nil
  end
  local next_record = copy(record)
  if tools_used then
    next_record.stalls = 0
  else
    next_record.stalls = next_record.stalls + 1
  end
  if not tools_used and next_record.stalls >= limits.stalls then
    next_record.status = "paused"
    next_record.summary = nil
    next_record.audit_reason = string.format(
      "no tool calls for %d consecutive goal turns; /goal resume to continue",
      next_record.stalls
    )
    next_record.updated_at = now
    return next_record, "paused"
  end
  if next_record.rounds >= limits.rounds then
    next_record.status = "paused"
    next_record.summary = nil
    next_record.audit_reason =
      string.format("reached the limit of %d rounds; /goal resume to continue", limits.rounds)
    next_record.updated_at = now
    return next_record, "paused"
  end
  next_record.rounds = next_record.rounds + 1
  next_record.updated_at = now
  return next_record, "continue"
end

function M.format(record, interrupted, max_rounds)
  if not record then
    return "No goal is set for this session."
  end
  local status = interrupted and "interrupted (use /goal resume)" or record.status
  local lines = {
    "Objective: " .. record.objective,
    "Status: " .. status,
    string.format("Rounds: %d/%d", record.rounds, max_rounds or 0),
    string.format("Goal %s / execution %s", record.id, record.execution_id),
  }
  if record.summary then
    lines[#lines + 1] = "Summary: " .. record.summary
  end
  if record.audit_reason then
    lines[#lines + 1] = "Last audit: " .. record.audit_reason
  end
  return table.concat(lines, "\n")
end

function M.hint(record, interrupted, max_rounds)
  if not record then
    return nil
  end
  if interrupted then
    return " Goal interrupted · /goal resume "
  end
  if record.status == "active" then
    return string.format(" Goal · %d/%d ", record.rounds, max_rounds)
  end
  if record.status == "auditing" then
    return " Goal · auditing "
  end
  if record.status == "paused" then
    return " Goal paused · /goal resume "
  end
  if record.status == "blocked" then
    return " Goal blocked · /goal resume "
  end
  return " Goal achieved "
end

return M
