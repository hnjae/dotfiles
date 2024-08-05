---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("state.treesitter-langs"):add("toml")
    end,
  },
  {
    -- NOTE: dprint(formatter) requires extra step before available to use <2024-01-04>
    -- https://dprint.dev/plugins/toml/

    -- :h conform-formatters
    -- https://github.com/stevearc/conform.nvim/tree/master/lua/conform/formatters
    [1] = "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft.toml = {
        "taplo",
      }
    end,
  },
  {
    [1] = "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        taplo = {
          ---@class LspconfigSetupOptsSpec
          settings = {},
        },
      },
    },
  },
}
