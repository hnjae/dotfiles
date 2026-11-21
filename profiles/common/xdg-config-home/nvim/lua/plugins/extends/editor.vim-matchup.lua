-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

---@type LazySpec
return {
  [1] = "andymass/vim-matchup",
  -- event = "VeryLazy", -- maybe something else
  lazy = false,
  init = function()
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
  end,
}
