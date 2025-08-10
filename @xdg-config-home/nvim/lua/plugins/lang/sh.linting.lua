---@type LazySpec
return {
  [1] = "nvim-lint",
  optional = true,
  opts = {
    linters_by_ft = {
      sh = { "shellcheck" },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "shellcheck" } },
    },
  },
}
