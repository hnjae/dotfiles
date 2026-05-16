---@type LazySpec
return {
  --[[
    NOTE:
      - PKM Markdown Language Server
      - <https://github.com/Feel-ix-343/markdown-oxide>
      - nvim-lspconfig built-in server name: markdown_oxide
  --]]
  [1] = "neovim/nvim-lspconfig",
  optional = true,
  opts = {
    -- ---@type lspconfig.options
    servers = {
      markdown_oxide = {
        enabled = true,
        root_markers = { ".obsidian" },
        workspace_required = true,
        capabilities = {
          workspace = {
            -- Recommended by markdown-oxide for unresolved-file actions and code block indexing.
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        },
      },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "markdown-oxide" } },
    },
  },
}
