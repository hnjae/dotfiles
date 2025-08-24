---@type LazySpec
return {
  --[[
    NOTE:
      - Naive linter for English prose
      - <https://github.com/btford/write-good>
      - Markdown (2025-04-09)

      - `nvim-lint` does not support write-good (2025-04-10)
  --]]
  [1] = "nvim-lint",
  optional = true,
  opts = {
    linters_by_ft = {
      text = { "write-good" },
      markdown = { "write-good" },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "write-good" } },
    },
  },
}
