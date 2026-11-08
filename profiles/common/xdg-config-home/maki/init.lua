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
  agent = {
    -- Compact once 50% of the window is spent, leaving the rest as working
    -- room. The default 20% reserves too little for long sessions.
    compaction_buffer = "50%",
  },
})

require("herdr")
require("secrets_guard")
require("wakelock")

-- Open the chat input in $EDITOR. Bound in both modes so it works whether
-- the input has the keyboard or a picker just closed.
maki.keymap.set({ "n", "i" }, "<C-g>", function()
  maki.ui.action("edit_input")
end, { desc = "Edit input in $EDITOR" })

-- Flip between plan and build. `<Tab>` is swallowed below so this is the
-- only key that switches modes.
local function toggle_mode()
  local info, err = maki.session.read()
  if not info then
    maki.notify("Mode switch failed: " .. tostring(err), "warn", { title = "maki" })
    return
  end
  local next_mode = info.mode == "plan" and "build" or "plan"
  local ok, set_err = maki.session.set_mode(next_mode)
  if not ok then
    maki.notify("Mode switch failed: " .. tostring(set_err), "warn", { title = "maki" })
  end
end

maki.keymap.set({ "n", "i" }, "<S-Tab>", toggle_mode, { desc = "Toggle plan/build mode" })

-- Take `<Tab>` away from the stock plan/build switch. Not calling
-- `ev.fallback()` is what stops Maki's own handling.
maki.keymap.set({ "n", "i" }, "<Tab>", function() end, { desc = "Disabled" })

-- A vim-style insert/normal switch on `<C-Esc>`, leaving plain `<Esc>` to
-- Maki so `Esc Esc` keeps working. `i` goes back to insert.
maki.keymap.set("i", "<C-Esc>", function()
  maki.ui.set_mode("n")
end, { desc = "Leave insert mode" })

maki.keymap.set("n", "i", function()
  maki.ui.set_mode("i")
end, { desc = "Enter insert mode" })

-- Show the input mode in the status bar, so normal mode is visible.
-- The label is empty on purpose: the mode name is the whole message.
local function show_mode()
  if maki.fn.mode() == "n" then
    maki.ui.set_status_hint({ { "NORMAL", "" } })
  else
    maki.ui.set_status_hint({ { "INPUT", "" } })
  end
end

maki.api.create_autocmd("ModeChanged", { callback = show_mode })
