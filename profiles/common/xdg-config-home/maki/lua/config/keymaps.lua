-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

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

-- default: `<C-b>`
maki.keymap.set("n", "<C-S-b>", function()
  maki.ui.action("background")
end)
