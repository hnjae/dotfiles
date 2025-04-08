---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "typst" } },
  },
  {
    [1] = "conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        typst = { "typstyle" },
      },
    },
    specs = {
      {
        [1] = "mason.nvim",
        optional = true,
        opts = { ensure_installed = { "typstyle" } },
      },
    },
  },
  {
    [1] = "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        tinymist = {
          enabled = true,
        },
      },
    },
    specs = {
      {
        [1] = "mason.nvim",
        optional = true,
        opts = { ensure_installed = { "tinymist" } },
      },
    },
  },
  {
    [1] = "chomosuke/typst-preview.nvim",
    version = "*",
    build = function()
      require("typst-preview").update()
    end,

    lazy = true,
    ft = { "typst" },

    opts = {},
  },
}
