---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "fish" } },
  },
  {
    [1] = "nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        fish = { "fish" },
      },
    },
  },
  {
    [1] = "conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        fish = { "fish_indent" },
      },
    },
  },
}
