-- vim.ui.input, vim.ui.select 대체
---@type LazySpec
return {
  [1] = "stevearc/dressing.nvim",
  lazy = true,
  cond = not vim.g.vscode,

  event = { "VeryLazy" },
  opts = {
    input = {
      enabled = true,
    },
    select = {
      enabled = true,
    },
  },
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function()
        local icons = require("val").icons
        require("state.lualine-ft-data"):add({
          DressingInput = {
            display_name = "DressingInput",
            icon = icons.textbox,
          },
        })
      end,
    },
  },
}
