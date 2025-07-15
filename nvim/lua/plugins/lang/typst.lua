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
    opts = {
      invert_colors = vim.api.nvim_get_option_value("background", {}) == "dark",
      dependencies_bin = {
        ["tinymist"] = "tinymist", -- use mason installed tinymist
      },
    },
    keys = {
      { "<leader>cp", "<cmd>TypstPreview<cr>", desc = "typst-preview", ft = "typst" },
    },

    lazy = true,
    ft = { "typst" },
  },
}
