-- Hold off suspend while maki is working.
--
-- On a Linux desktop session, `systemd-inhibit --what=sleep` keeps the
-- machine awake for as long as the process holding the lock runs. `sleep`
-- alone is deliberate: `idle` would also stop the screen from blanking,
-- and a blanking screen is fine while a turn runs.
--
-- The lock follows `SessionStatusChanged`, which reports the whole session
-- rather than one turn: a background task the main agent waits on keeps it
-- at "working", so a turn boundary would drop the lock too early.
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

if not enabled then
  maki.log.info("wakelock: not a desktop session or systemd-inhibit missing, idle")
  return
end

maki.api.create_autocmd("SessionStatusChanged", {
  callback = function(ev)
    local status = ev.data and ev.data.status
    if status == "working" then
      acquire()
    elseif status == "idle" or status == "needs_input" then
      release()
    end
  end,
})

-- A session that ends while working leaves nobody to report idle.
maki.api.create_autocmd({ "SessionEnd", "SessionReset" }, {
  callback = function()
    release()
  end,
})
