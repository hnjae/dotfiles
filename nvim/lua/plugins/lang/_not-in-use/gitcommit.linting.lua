---@type LazySpec
return {
  --[[
      NOTE:
        - Lint commit messages
        - <https://github.com/conventional-changelog/commitlint>
        - <https://commitlint.js.org>
    --]]
  [1] = "nvim-lint",
  optional = true,
  opts = {
    linters_by_ft = {
      gitcommit = { "commitlint" },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "commitlint" } },
    },
  },
}
