-- 함수 선언문 같은 것을 상단에 고정해주는 플러그인

---@type LazySpec
return {
  [1] = "nvim-treesitter",
  optional = true,
  specs = {
    {
      [1] = "nvim-treesitter/nvim-treesitter-context",
      lazy = true,
      event = { "VeryLazy" },
      dependencies = {
        [1] = "nvim-treesitter",
      },
      opts = {
        max_lines = 3,
      },
    },
  },
}
