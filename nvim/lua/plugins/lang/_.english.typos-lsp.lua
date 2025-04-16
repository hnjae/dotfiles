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
    -- ---@type lspconfig.options
    servers = {
      typos_lsp = {
        enabled = true,
        init_options = {
          config = vim.fn.stdpath("config") .. "typos.toml",
          diagnosticSeverity = "Warning",
        },
      },
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
