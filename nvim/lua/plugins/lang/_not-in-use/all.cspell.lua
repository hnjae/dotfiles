---@type LazySpec[]
return {
  {
    [1] = "nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        ["*"] = { "cspell" },
      },
    },
  },
  {
    "mason.nvim",
    optional = true,
    opts = { ensure_installed = { "cspell" } },
  },
}
