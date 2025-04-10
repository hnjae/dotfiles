---@type LazySpec
return {
  --[[
    NOTE:
      - The Grammar Checker for Developers
      - <https://github.com/Automattic/harper>
      - <https://writewithharper.com/docs/integrations/language-server>
  --]]
  [1] = "neovim/nvim-lspconfig",
  optional = true,
  opts = {
    servers = {
      harper_ls = { enabled = true },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "harper-ls" } },
    },
  },
}
