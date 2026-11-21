-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

---@type LazySpec[]
return {
  {
    [1] = "lazy.nvim",
    optional = true,
    opts = function()
      vim.g.lazyvim_python_lsp = "tsgo"
    end,
  },
}
