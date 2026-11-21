-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

---@type LazySpec
return {
  [1] = "trouble.nvim",
  optional = true,
  opts = {
    icons = {
      -- kinds = vim.deepcopy(LazyVim.config.icons.kinds),
    },
    modes = {
      symbols = {
        auto_open = false,
        ---@type trouble.Window.opts
        win = {
          -- default: 30?
          size = 26,
        },
      },
    },
  },
}
