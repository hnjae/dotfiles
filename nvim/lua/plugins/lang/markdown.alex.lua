---@type LazySpec
return {
  --[[
    NOTE:
      - Catch insensitive, inconsiderate writing
      - <https://github.com/get-alex/alex>
      - Markdown (2025-04-09)
  --]]
  [1] = "nvim-lint",
  optional = true,
  opts = {
    linters_by_ft = {
      text = { "alex" },
      markdown = { "alex" },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "alex" } },
    },
  },
}
