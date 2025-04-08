---@type LazySpec
return {
  [1] = "conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      sh = {
        [1] = "shellharden",
        [2] = "shellcheck",
        [3] = "shfmt",
        stop_after_first = false,
      },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "shellharden", "shellcheck", "shfmt" } },
    },
  },
}
