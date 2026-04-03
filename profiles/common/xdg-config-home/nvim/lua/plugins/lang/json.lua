---@type LazySpec[]
return {
  {
    "conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        json = { "biome", "jq", lsp_format = "fallback" },
      },
    },
  },
  -- {
  --   [1] = "nvim-lspconfig",
  --   optional = true,
  --   -- ---@type lspconfig.options
  --   opts = {
  --     servers = {
  --       -- use biome instead
  --       -- jsonls = {
  --       --   enabled = false,
  --       --   mason = false,
  --       -- },

  --     },
  --   },
  -- },
}
