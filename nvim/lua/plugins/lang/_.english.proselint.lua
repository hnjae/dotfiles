---@type LazySpec
return {
  --[[
    NOTE:
      - A linter for prose.
      - <https://github.com/amperser/proselint>
    --]]
  [1] = "nvim-lint",
  optional = true,
  opts = {
    linters_by_ft = {
      text = { "proselint" },
      markdown = { "proselint" },
      asciidoc = { "proselint" },
      org = { "proselint" },
      rst = { "proselint" },
      tex = { "proselint" },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "proselint" } },
    },
  },
}
