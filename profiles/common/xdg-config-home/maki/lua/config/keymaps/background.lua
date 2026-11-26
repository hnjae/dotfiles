-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- default: `<C-b>`
maki.keymap.set("n", "<C-S-b>", function()
  maki.ui.action("background")
end)
