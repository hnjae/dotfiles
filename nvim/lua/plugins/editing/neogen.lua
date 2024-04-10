-- annotation generator

---@type LazySpec
return {
  [1] = "danymat/neogen",
  lazy = false,
  enabled = require("utils").is_treesitter,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = {
    "Neogen",
  },
  opts = {
    snippet_engine = "snippy",
  },
  config = true,
}
