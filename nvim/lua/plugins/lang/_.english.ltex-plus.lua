---@type LazySpec
return {
  [1] = "neovim/nvim-lspconfig",
  optional = true,
  opts = {
    servers = {
      ltex_plus = {
        enabled = true,
      },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "ltex-ls-plus" } },
    },
  },
}
