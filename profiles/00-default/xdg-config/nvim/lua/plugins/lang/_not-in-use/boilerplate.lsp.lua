---@type LazySpec
return {
  [1] = "neovim/nvim-lspconfig",
  optional = true,
  opts = {
    servers = {
      foo = {
        enabled = true,
      },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      -- Mason 열어서 제공하는지 확인할 것.
      opts = { ensure_installed = { "foo" } },
    },
  },
}
