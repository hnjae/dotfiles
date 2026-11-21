-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "xml" } },
  },
  {
    [1] = "conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        xml = { "xmlformatter" },
      },
    },
    specs = {
      {
        [1] = "mason.nvim",
        optional = true,
        opts = { ensure_installed = { "xmlformatter" } },
      },
    },
  },
}
