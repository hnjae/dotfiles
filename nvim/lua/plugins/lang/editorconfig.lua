---@type LazySpec[]
return {
  {
    [1] = "nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        editorconfig = { "editorconfig-checker" },
      },
    },
  },
  {
    "mason.nvim",
    optional = true,
    opts = { ensure_installed = { "editorconfig-checker" } },
  },
}
