---@type LazySpec
return {
  [1] = "neovim/nvim-lspconfig",
  optional = true,
  opts = {
    servers = {
      ast_grep = { enabled = true },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "ast-grep" } },
    },
  },
}
