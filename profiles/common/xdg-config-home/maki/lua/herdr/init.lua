-- Report maki's agent state to herdr, in both of its front ends.
--
-- herdr TUI: reports through `herdr pane report-agent` (see herdr/tui.lua).
-- herdr app: there is no report command, so the app learns state from
-- OSC 7501 on the pane's output (see herdr/app.lua).
--
-- The status mapping, focused-session tracking, and event wiring are shared;
-- only the transport differs. Nothing happens outside herdr.

local DEBOUNCE_MS = 120

local function env(name)
  local value = maki.uv.os_getenv(name)
  if value == nil or value == "" then
    return nil
  end
  return value
end

local pane_id = env("HERDR_PANE_ID")
local bin = env("HERDR_BIN_PATH")
-- Prefer the TUI when both are set: maki then runs inside the TUI, and the
-- app sees the TUI, not maki.
local transport
if env("HERDR_ENV") == "1" then
  if pane_id ~= nil and bin ~= nil then
    transport = require("herdr.tui").new({ pane_id = pane_id, bin = bin })
  end
elseif env("HC_TERMINAL_ID") ~= nil then
  transport = require("herdr.app").new()
end

if transport == nil then
  return {}
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
    transport.report(state, session_id)
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
    transport.report(state, session_id)
  end,
})

-- The user has to answer something: maki raises a notification for it.
-- Chain to whatever handler was installed before us so the notice still
-- shows the way the user configured it.
maki.set_notify_handler(function(msg, level, opts)
  local session_id = maki.session.current()
  if session_id == focused and level ~= "info" then
    transport.report("blocked", session_id)
  end
  maki.ui.flash(msg)
end)

maki.api.create_autocmd("SessionEnd", {
  callback = function(ev)
    local data = ev.data or {}
    transport.session_ended(data.reason)
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
    transport.report(state, session_id)
  end)
end

return {}
