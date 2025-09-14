---@type LazySpec
return {
  [1] = "conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      -- yaml = { "yamlfmt" },
      -- yaml = { "yq" },
      yaml = { "yamlfix" },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      -- opts = { ensure_installed = { "yamlfmt" } },
      opts = { ensure_installed = { "yamlfix" } },
    },
  },
}
