-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- herdr TUI transport: report through `herdr pane report-agent`.
--
-- Contract that matters, from the herdr doc "Add Herdr support to your
-- agent":
--   * --source must be stable and unique. One value for the whole plugin.
--   * --seq must strictly increase across sessions and agent restarts, or
--     herdr drops the report. We use a monotonic millisecond clock.
--   * The resume command goes after `--`, first word is a bare command name.
--   * Send the resume command with a state report, not on its own, so the
--     source already holds the pane.

local SOURCE = "maki"
local AGENT = "maki"

local M = {}

function M.new(opts)
  local pane_id = opts.pane_id
  local bin = opts.bin

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
      bin,
      "pane",
      "report-agent",
      pane_id,
      "--source",
      SOURCE,
      "--agent",
      AGENT,
      "--state",
      state,
      "--seq",
      tostring(next_seq()),
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

  -- Release only when the user actually quits. A reload keeps the session
  -- running in the new plugin host, so it is not a quit.
  local function session_ended(reason)
    if reason ~= "shutdown" and reason ~= "delete" and reason ~= "completed" then
      return
    end
    maki.fn.jobstart({
      bin,
      "pane",
      "release-agent",
      pane_id,
      "--source",
      SOURCE,
      "--agent",
      AGENT,
      "--seq",
      tostring(next_seq()),
    }, { scope = "plugin", stdout = false, stderr = false })
  end

  return { report = report, session_ended = session_ended }
end

return M
