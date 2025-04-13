--[[
  NOTE:
    - textlint is the pluggable linter for natural language text.
    - <https://github.com/textlint/textlint>
    - text, Markdown (2025-04-09)

    - `nvim-lint` does not support textlint (2025-04-10)
--]]

---@type LazySpec
return {
  [1] = "none-ls.nvim",
  optional = true,
  opts = function(_, opts)
    local nls = require("null-ls")

    opts.sources = vim.list_extend(opts.sources or {}, {
      nls.builtins.diagnostics.textlint,
    })
  end,
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "textlint" } },
    },
  },
}
