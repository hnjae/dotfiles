---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("plugins.core.treesitter.languages"):add("xml")
    end,
  },
  {
    -- :h conform-formatters
    -- https://github.com/stevearc/conform.nvim/tree/master/lua/conform/formatters
    [1] = "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        xml = {
          [1] = "xmllint",
          [2] = "xmlformat",
          stop_after_first = false,
        },
      },
    },
  },
}
