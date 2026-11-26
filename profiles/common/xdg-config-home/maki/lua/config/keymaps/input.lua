-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- Open the chat input in $VISUAL. Bound in both modes so it works whether
-- the input has the keyboard or a picker just closed.
maki.keymap.set({ "n", "i" }, "<C-g>", function()
  maki.ui.action("edit_input")
end, { desc = "Edit input in $VISUAL" })

-- A vim-style insert/normal switch on `<C-Esc>`, leaving plain `<Esc>` to
-- Maki so `Esc Esc` keeps working. `i` goes back to insert.
maki.keymap.set("i", "<C-Esc>", function()
  maki.ui.set_mode("n")
end, { desc = "Leave insert mode" })

maki.keymap.set("n", "i", function()
  maki.ui.set_mode("i")
end, { desc = "Enter insert mode" })
