---@type LazySpec
return {
  --[[
    NOTE:
      - Source code spell checker for Visual Studio Code, Neovim, and other LSP clients
      - <https://github.com/tekumara/typos-lsp>
  --]]
  [1] = "neovim/nvim-lspconfig",
  optional = true,
  opts = {
    servers = {
      typos_lsp = { enabled = true },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "typos-lsp" } },
    },
  },
}
