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
    [1] = "nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        tinymist = {
          enabled = true,
          -- TODO: root_dir 말고 lspconfig 에서 정의된, root_marker 자체를 override 할수는 없나?  <2025-09-05>
          -- snacks 등에서 Lazyvim.root() 처리를 더 용이하게 하기 위해서.
          root_dir = require("lspconfig").util.root_pattern("main.typ", ".git"),
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
    version = "1.*",
    opts = {
      debug = true,
      -- invert_colors = vim.api.nvim_get_option_value("background", {}) == "dark",
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
