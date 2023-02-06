return {
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    dependencies = {
      "williamboman/mason.nvim" -- mason should been setuped before mason-lspconfig
    },
    opts = {
      ensure_installed = {
        "rust_analyzer",
      },
    },
  },
  {
    "williamboman/mason.nvim",
    lazy = true,
    opts = {},
  },
}
