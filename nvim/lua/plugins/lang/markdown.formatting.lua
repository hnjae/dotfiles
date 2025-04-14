--[[
  NOTE:

  Comparison of markdown formatter (2025-04-13):
    - `mdformat`
      indent 를 조정하는 옵션을 제공하지 않음.
    - `deno`
      markdown 의 경우 indent 를 2로 고정. 조정할 수 없음.
    - `markdownlint-cli2`
      `.markdownlint-cli2.jsonc` 파일을 통해 indent 를 조정할 수 있음.
]]
---@type LazySpec
return {
  [1] = "conform.nvim",
  optional = true,
  opts = function(_, opts)
    opts.formatters = opts.formatters or {}

    opts.formatters["markdownlint-cli2"] =
      vim.tbl_extend("force", opts.formatters["markdownlint-cli2"] or {}, {
        cwd = require("conform.util").root_file({
          ".markdownlint-cli2.jsonc",
          ".markdownlint-cli2.yaml",
          ".markdownlint-cli2.cjs",
          ".markdownlint-cli2.mjs",
          ".markdownlint.jsonc",
          ".markdownlint.json",
          ".markdownlint.yaml",
          ".markdownlint.yml",
          ".markdownlint.cjs",
          ".markdownlint.mjs",
        }),
        require_cwd = false,
        condition = function(_, _)
          return true
        end,
      })

    return opts
  end,
}
