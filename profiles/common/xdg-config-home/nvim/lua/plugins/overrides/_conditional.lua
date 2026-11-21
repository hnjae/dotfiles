-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

local have_cc = require("lazyvim.util.treesitter").check()

---@type LazySpec[]
return {
  {
    [1] = "none-ls.nvim",
    optional = true,
    enabled = false,
  },
  {
    [1] = "nvim-treesitter",
    optional = true,
    enabled = have_cc,
  },
  {
    [1] = "LuaSnip",
    optional = true,
    enabled = vim.fn.executable("make") == 1,
  },
}
