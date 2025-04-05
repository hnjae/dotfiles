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
        local icons = require("globals").icons
        require("plugins.core.lualine.utils.buffer-attributes"):add({
          DressingInput = {
            display_name = "DressingInput",
            icon = icons.textbox,
          },
        })
      end,
    },
  },
}
