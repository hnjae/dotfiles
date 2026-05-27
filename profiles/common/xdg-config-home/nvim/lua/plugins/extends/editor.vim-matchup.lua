---@type LazySpec
return {
  [1] = "andymass/vim-matchup",
  -- event = "VeryLazy", -- maybe something else
  lazy = false,
  init = function()
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
  end,
}
