---@type LazySpec[]
return {
  { [1] = "imsnif/kdl.vim", lazy = false },
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("state.treesitter-langs"):add("kdl")
    end,
  },
}
