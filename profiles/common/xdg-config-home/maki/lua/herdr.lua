-- Report maki's agent state and resumable session to herdr.
--
-- herdr has no `integration install maki` target. maki is a "state only"
-- agent there: herdr scrapes the status bar. This plugin upgrades that to
-- the documented self-reporting path (herdr docs: "Add Herdr support to
-- your agent"), which also enables native session restore.
--
-- Contract that matters, from that doc:
--   * --source must be stable and unique. One value for the whole plugin.
--   * --seq must strictly increase across sessions and agent restarts, or
--     herdr drops the report. We use a monotonic millisecond clock.
--   * The resume command goes after `--`, first word is a bare command name.
--   * Send the resume command with a state report, not on its own, so the
--     source already holds the pane.
--   * Nothing happens outside herdr.

local SOURCE = "maki"
local AGENT = "maki"
local DEBOUNCE_MS = 120

local pane_id = maki.uv.os_getenv("HERDR_PANE_ID")
local bin = maki.uv.os_getenv("HERDR_BIN_PATH")
local enabled = maki.uv.os_getenv("HERDR_ENV") == "1"
  and pane_id ~= nil and pane_id ~= ""
  and bin ~= nil and bin ~= ""

if not enabled then
  return {}
end

-- Strictly increasing sequence. Herdr ignores a report whose seq is not
-- higher than the last one it accepted, so this must never repeat, even
-- across a plugin reload in the same process.
local last_seq = 0
local function next_seq()
  -- os.time() is whole seconds; keep a counter to stay monotonic inside one.
  local now = os.time() * 1000 + (last_seq % 1000) + 1
  if now <= last_seq then
    now = last_seq + 1
  end
  last_seq = now
  return now
end

-- Latest desired state. Only the newest report matters; older ones are
-- dropped while a report is in flight.
local pending = nil
local running = false

local function build_argv(state, session_id)
  local argv = {
    bin, "pane", "report-agent", pane_id,
    "--source", SOURCE,
    "--agent", AGENT,
    "--state", state,
    "--seq", tostring(next_seq()),
  }
  if session_id and session_id ~= "" then
    argv[#argv + 1] = "--agent-session-id"
    argv[#argv + 1] = session_id
    argv[#argv + 1] = "--"
    argv[#argv + 1] = "maki"
    argv[#argv + 1] = "-r"
    argv[#argv + 1] = session_id
  end
  return argv
end

local function drain()
  if running or pending == nil then
    return
  end
  local report = pending
  pending = nil
  running = true
  -- scope = "plugin" so the job survives the autocmd callback that started
  -- it; a default "task" scope job dies with the dispatch.
  local ok, err = maki.fn.jobstart(build_argv(report.state, report.session_id), {
    scope = "plugin",
    stdout = false,
    stderr = false,
    on_exit = function()
      running = false
      drain()
    end,
  })
  if not ok then
    running = false
    maki.log.warn("herdr: report failed to start: " .. tostring(err))
  end
end

local function report(state, session_id)
  pending = { state = state, session_id = session_id }
  drain()
end

-- Map maki's three statuses onto herdr's. needs_input means maki is asking
-- the user something, which is herdr's `blocked`.
local function map_status(status)
  if status == "working" then
    return "working"
  elseif status == "needs_input" then
    return "blocked"
  elseif status == "idle" then
    return "idle"
  end
  return nil
end

-- Which session this pane is showing. maki does not hand a plugin the pane's
-- owning session, so we track the focused one. Background tabs report their
-- own status changes and are ignored.
local focused = maki.session.current()

local function on_status(ev)
  local data = ev.data or {}
  local session_id = data.session_id
  if session_id == nil then
    return
  end
  if session_id ~= focused then
    return
  end
  local state = map_status(data.status)
  if state then
    report(state, session_id)
  end
end

maki.api.create_autocmd("SessionStatusChanged", { callback = on_status })

maki.api.create_autocmd("SessionFocusChanged", {
  callback = function(ev)
    local data = ev.data or {}
    local session_id = data.session_id
    if session_id == nil or session_id == "" then
      return
    end
    focused = session_id
    local live = maki.session.live()
    local state = "idle"
    if live then
      for _, s in ipairs(live) do
        if s.id == session_id then
          state = map_status(s.status) or "idle"
          break
        end
      end
    end
    report(state, session_id)
  end,
})

-- The user has to answer something: maki raises a notification for it.
-- Chain to whatever handler was installed before us so the notice still
-- shows the way the user configured it.
maki.set_notify_handler(function(msg, level, opts)
  local session_id = maki.session.current()
  if session_id == focused and level ~= "info" then
    report("blocked", session_id)
  end
  maki.ui.flash(msg)
end)

-- Release only when the user actually quits. A reload keeps the session
-- running in the new plugin host, so it is not a quit.
maki.api.create_autocmd("SessionEnd", {
  callback = function(ev)
    local data = ev.data or {}
    local reason = data.reason
    if reason == "shutdown" or reason == "delete" or reason == "completed" then
      maki.fn.jobstart({
        bin, "pane", "release-agent", pane_id,
        "--source", SOURCE,
        "--agent", AGENT,
        "--seq", tostring(next_seq()),
      }, { scope = "plugin", stdout = false, stderr = false })
    end
  end,
})

-- Announce ourselves once at load so herdr knows this pane is ours and gets
-- the resume command for the session already open.
do
  local session_id = focused
  local live = maki.session.live()
  local state = "idle"
  if live then
    for _, s in ipairs(live) do
      if s.id == session_id then
        state = map_status(s.status) or "idle"
        break
      end
    end
  end
  maki.async.spawn(function()
    maki.async.sleep(DEBOUNCE_MS)
    report(state, session_id)
  end)
end

return {}
