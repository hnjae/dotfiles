-- 함수 선언문 같은 것을 고정해주는 플러그인
return {
  [1] = "nvim-treesitter/nvim-treesitter-context",
  lazy = true,
  cond = require("utils").is_treesitter,
  event = { "VeryLazy" },
  dependencies = {
    [1] = "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    max_lines = 3,
  },
}
