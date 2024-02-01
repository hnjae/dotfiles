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
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
  },
}
