---@type LazySpec
return {
  [1] = "stevearc/dressing.nvim",
  lazy = true,
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
          DressingInput = { [1] = "DressingInput", [2] = icons.textbox },
        })
      end,
    },
  },
}
