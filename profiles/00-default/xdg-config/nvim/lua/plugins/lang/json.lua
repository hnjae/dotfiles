---@type LazySpec[]
return {
  {
    [1] = "nvim-lint",
    optional = true,
    opts = {
      -- linters_by_ft = {
      --   json = { "jsonlint" },
      -- },
    },
    specs = {
      -- {
      --   [1] = "mason.nvim",
      --   optional = true,
      --   opts = { ensure_installed = { "jsonlint" } },
      -- },
    },
  },
  {
    [1] = "nvim-lspconfig",
    optional = true,
    -- ---@type lspconfig.options
    opts = {
      servers = {
        -- use biome instaed
        -- jsonls = {
        --   enabled = false,
        --   mason = false,
        -- },
      },
    },
  },
}
