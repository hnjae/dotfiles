-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

--[[
  NOTE:
    Enable `lang.json` from LazyExtra
--]]

---@type LazySpec[]
return {
  {
    "conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        json = { "biome", lsp_format = "never" },
        jsonc = { "biome", lsp_format = "never" },
      },
    },
  },
}
