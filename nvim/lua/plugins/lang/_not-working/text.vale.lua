---@type LazySpec
return {
  --[[
    NOTE:
      - A markup-aware linter for prose built with speed and extensibility in mind.
      - <https://github.com/errata-ai/vale>
      - text, markdown, latex (2025-04-09)
  --]]
  [1] = "nvim-lint",
  optional = true,
  opts = {
    linters_by_ft = {
      text = { "vale" },
      markdown = { "vale" },
      tex = { "vale" },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "vale" } },
    },
  },
}
