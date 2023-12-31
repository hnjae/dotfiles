return {
  [1] = "nvim-treesitter/nvim-treesitter-context",
  lazy = true,
  event = {
    "InsertEnter",
  },
  dependencies = {
    [1] = "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    max_lines = 3,
  },
}
