---@type LazySpec[]
return {
  { [1] = "imsnif/kdl.vim", lazy = false },
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("plugins.core.treesitter.languages"):add("kdl")
    end,
  },
}
