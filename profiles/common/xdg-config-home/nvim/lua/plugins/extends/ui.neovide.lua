-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

---@type LazySpec
return {
  [1] = "sevenc-nanashi/neov-ime.nvim",
  lazy = false,
  enabled = vim.fn.has("nvim-0.12") ~= 0,
}
