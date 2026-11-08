-- Notification mode: desktop notifications on a graphical Linux session,
-- otherwise maki's default "auto" (OSC 9 in a supported terminal, BEL else).
--
-- maki's "notify" mode needs a D-Bus session bus. The check is only a hint:
-- if the bus disappears later, maki's own fallback handles it.
local function desktop_session()
  if maki.uv.os_getenv("HERDR_ENV") == "1" then
    return false
  end
  if maki.uv.os_getenv("XDG_SESSION_TYPE") == nil then
    return false
  end
  local bus = maki.uv.os_getenv("DBUS_SESSION_BUS_ADDRESS")
  if bus == nil or bus == "" then
    return false
  end
  return true
end

maki.setup({
  ui = {
    notifications = desktop_session() and "notify" or "auto",
  },
})

require("herdr")
require("secrets_guard")
require("wakelock")
