---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("state.treesitter-langs"):add("rust")
    end,
  },
  {
    [1] = "rust-lang/rust.vim",
    lazy = true,
    enabled = false,
    ft = { "rust" },
    init = function() end,
  },
}
