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
