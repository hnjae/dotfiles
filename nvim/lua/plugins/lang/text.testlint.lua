---@type LazySpec
return {
  --[[
    NOTE:
      - textlint is the pluggable linter for natural language text.
      - <https://github.com/textlint/textlint>
      - text, markdown (2025-04-09)
  --]]
  [1] = "nvim-lint",
  optional = true,
  opts = {
    linters_by_ft = {
      text = { "textlint" },
      markdown = { "textlint" },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "textlint" } },
    },
  },
}
