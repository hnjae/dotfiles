---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("state.treesitter-langs"):add("typst")
    end,
  },
  {
    [1] = "kaarmu/typst.vim",
    lazy = false,
  },
  {
    [1] = "chomosuke/typst-preview.nvim",
    lazy = true,
    ft = { "typst" },
    enabled = false,
    build = function()
      require("typst-preview").update()
    end,
  },
  {
    [1] = "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        tinymist = {
          ---@class LspconfigSetupOptsSpec
          settings = {},
        },
      },
    },
  },
  {
    -- :h conform-formatters
    -- https://github.com/stevearc/conform.nvim/tree/master/lua/conform/formatters
    [1] = "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        typst = {
          "typstfmt",
        },
      },
    },
  },
}
