-- 우 하단, LSP 로딩하는것 알려주는 플러그인
---@type LazySpec
return {
  [1] = "j-hui/fidget.nvim",
  lazy = true,
  event = "VeryLazy",
  enabled = true,
  tag = "v1.4.5",
  opts = {
    logger = {
      path = string.format("%s/fidget.nvim.log", vim.fn.stdpath("state")),
    },
  },
}
