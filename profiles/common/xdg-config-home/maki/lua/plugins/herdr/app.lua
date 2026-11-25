-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- herdr app transport: report through OSC 7501 on the pane's output.
--
-- The app has no report command. It learns agent state from OSC 7501, so
-- write the sequence to our own terminal. A job child is setsid'd and has no
-- controlling tty, so this has to happen in maki's process; /dev/stdout is
-- the same pty when /dev/tty is unavailable.
--
-- OSC 7501 carries no resume command, so app support is state only.

local AGENT = "maki"

local M = {}

function M.new()
  local last_state = nil
  local warned = false

  local function write_osc(state)
    local payload = "\27]7501;state=" .. state .. ":app=" .. AGENT .. "\27\\"
    local ok, err = maki.fs.write("/dev/tty", payload)
    if not ok then
      ok, err = maki.fs.write("/dev/stdout", payload)
    end
    if not ok then
      if not warned then
        warned = true
        maki.log.warn("herdr: OSC write failed: " .. tostring(err))
      end
      return false
    end
    return true
  end

  local function report(state, _session_id)
    if state == last_state then
      return
    end
    if write_osc(state) then
      last_state = state
    end
  end

  local function session_ended(reason)
    -- maki is exiting and the app stays up. maki.fs.write is allowed during
    -- teardown, unlike a job, so clear the report here. Other reasons leave
    -- maki running on another session, so the pane is still an agent.
    if reason ~= "shutdown" then
      return
    end
    if write_osc("clear") then
      last_state = "clear"
    end
  end

  return { report = report, session_ended = session_ended }
end

return M
