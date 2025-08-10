---@type LazySpec
return {
  [1] = "conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      python = {
        -- "ruff_fix"
        [1] = "ruff_organize_imports",
        [2] = "ruff_format",
        stop_after_first = false,
      },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "ruff" } },
    },
  },
}
