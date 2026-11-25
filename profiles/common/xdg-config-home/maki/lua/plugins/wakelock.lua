-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- Hold off suspend while maki is working.
--
-- On a Linux desktop session, `systemd-inhibit --what=sleep` keeps the
-- machine awake for as long as the process holding the lock runs. `sleep`
-- alone is deliberate: `idle` would also stop the screen from blanking,
-- and a blanking screen is fine while a turn runs.
--
-- The lock follows `SessionStatusChanged`, which reports the whole session
-- rather than one turn: a turn that ended with work still running keeps the
-- session at "working", so a turn boundary would drop the lock too early.
-- That status counts moved calls, awaited subagents, and plugin sessions no
-- turn waits on, but it is reported per session. One lock serves every
-- session tab, so the set below decides, not the last event.
--
-- maki's Lua has no D-Bus binding, and `Inhibit` lives on the system bus
-- anyway, so the lock is a `systemd-inhibit` child process. Killing it
-- releases the lock.

local WHO = "maki"
local WHY = "maki is working"

local function is_desktop_session()
  if maki.uv.os_getenv("XDG_SESSION_TYPE") == nil then
    return false
  end
  local bus = maki.uv.os_getenv("DBUS_SESSION_BUS_ADDRESS")
  return bus ~= nil and bus ~= ""
end

local function has_systemd_inhibit()
  return maki.fn.executable("systemd-inhibit") ~= nil
end

local enabled = is_desktop_session() and has_systemd_inhibit()

local job_id = nil
-- One notice per run: a lock that keeps failing would otherwise pop up on
-- every turn. The log keeps every failure.
local notified = false
-- Session ids whose session is working. A session going idle must not drop
-- the lock another session still needs.
local working = {}

local function release()
  if job_id then
    maki.fn.jobstop(job_id)
    job_id = nil
  end
end

local function acquire()
  if job_id or not enabled then
    return
  end
  local id, err = maki.fn.jobstart({
    "systemd-inhibit",
    "--what=sleep",
    "--who=" .. WHO,
    "--why=" .. WHY,
    "--mode=block",
    "sleep",
    "infinity",
  }, {
    scope = "plugin",
    stdout = false,
    stderr = false,
    on_exit = function()
      job_id = nil
    end,
  })
  if not id then
    local reason = tostring(err)
    maki.log.warn("wakelock: systemd-inhibit failed to start: " .. reason)
    if not notified then
      notified = true
      maki.notify("Suspend lock failed: " .. reason, "warn", { title = "maki" })
    end
    return
  end
  job_id = id
end

local function refresh()
  if next(working) then
    acquire()
  else
    release()
  end
end

-- `/reload` tears the plugin's job down with it and no status change follows,
-- so the first focus of the new host asks which sessions are still working.
-- A tab switch lands here too, which keeps the set honest for free.
local function reseed()
  local live = maki.session.live()
  if not live then
    return
  end
  working = {}
  for _, session in ipairs(live) do
    if session.status == "working" then
      working[session.id] = true
    end
  end
  refresh()
end

if not enabled then
  maki.log.info("wakelock: not a desktop session or systemd-inhibit missing, idle")
  return
end

maki.api.create_autocmd("SessionStatusChanged", {
  callback = function(ev)
    local data = ev.data or {}
    local session = data.session_id
    local status = data.status
    if not session or not status then
      return
    end
    if status == "working" then
      working[session] = true
    elseif status == "idle" or status == "needs_input" then
      working[session] = nil
    else
      return
    end
    refresh()
  end,
})

maki.api.create_autocmd("SessionFocusChanged", {
  callback = reseed,
})

-- A session that ends while working leaves nobody to report idle. When even
-- the id is gone, the host is going down, so forget every session.
maki.api.create_autocmd({ "SessionEnd", "SessionReset" }, {
  callback = function(ev)
    local session = ev.data and ev.data.session_id
    if session then
      working[session] = nil
    else
      working = {}
    end
    refresh()
  end,
})
