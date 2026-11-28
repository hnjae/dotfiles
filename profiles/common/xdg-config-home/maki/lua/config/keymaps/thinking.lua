-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- `<S-Up>`/`<S-Down>` walk the effort ladder one level at a time. The stock
-- picker already owns that walk, including skipping a level the model sends as
-- another row, so the keys call it instead of re-deriving the ladder.
local thinking_window = require("thinking_window")

maki.keymap.set({ "n", "i" }, "<S-Up>", function()
  thinking_window.step(1)
end, { desc = "More thinking" })
maki.keymap.set({ "n", "i" }, "<S-Down>", function()
  thinking_window.step(-1)
end, { desc = "Less thinking" })
