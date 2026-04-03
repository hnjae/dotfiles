---@type LazySpec
return {
  [1] = "conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      toml = { "taplo" },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "taplo" } },
    },
  },
}
