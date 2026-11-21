-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

local description = "jump-to-next-closed-pair"

local M = {}

M.setup = function()
  local fun = "<C-\\><C-n>%%a"
  -- vim.keymap.set("i", "<A-p>", fun, { desc = description })
  vim.keymap.set("i", "<A-i>", fun, { desc = description })
  -- vim.keymap.set("i", "<F2>", fun, { desc = description })
  -- vim.keymap.set("i", "<C-5>", fun, { desc = description })
end

return M
