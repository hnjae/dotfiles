---@type LazySpec[]
return {
  {
    [1] = "nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        -- zsh = { "zsh", "shellharden" },
        zsh = { "zsh" },
      },
    },
    specs = {
      {
        [1] = "mason.nvim",
        optional = true,
        opts = { ensure_installed = { "shellharden" } },
      },
    },
  },
  -- TODO: set indent-size and tab option <2025-05-31>
  -- {
  --   [1] = "conform.nvim",
  --   optional = true,
  --   opts = {
  --     formatters_by_ft = {
  --       zsh = { "beautysh", stop_after_first = false },
  --     },
  --   },
  --   specs = {
  --     {
  --       [1] = "mason.nvim",
  --       optional = true,
  --       opts = { ensure_installed = { "beautysh" } },
  --     },
  --   },
  -- },
}
