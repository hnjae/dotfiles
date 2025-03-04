---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    init = function()
      --[[
      2025-03-03

      Parser/Features         H L F I J
      - nu                  ✓ . ✓ ✓ ✓
      ]]
      require("state.treesitter-langs"):add("nu")
    end,
  },
  {
    [1] = "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        nushell = {
          ---@class LspconfigSetupOptsSpec
          settings = {},
        },
      },
    },
  },
  {
    [1] = "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        -- NOTE: nufmt 가 고장난듯? indent 를 전부 없애버린다. <2025-03-03>
        -- nu = { [1] = "nufmt" },
      },
    },
  },
}
