-- replace cmdline, messages, popupmenu
---@type LazySpec
return {
  [1] = "folke/noice.nvim",
  lazy = true,
  enabled = true,
  event = {
    -- "VimEnter",
    "VeryLazy",
  },
  dependencies = {
    "rcarriga/nvim-notify",
    { [1] = "MunifTanjim/nui.nvim", module = true },
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    lsp = {
      progress = {
        enabled = false,
        throttle = 1000 / 500,
      },
    },
  },
}
