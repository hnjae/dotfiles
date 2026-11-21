-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "css" } },
  },
  {
    [1] = "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        cssls = {
          enabled = true,
        },
      },
    },
    specs = {
      {
        [1] = "mason.nvim",
        optional = true,
        opts = { ensure_installed = { "css-lsp" } },
      },
    },
  },
}
