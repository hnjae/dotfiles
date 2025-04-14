---@type LazySpec[]
return {
  {
    [1] = "none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      opts.sources = vim.tbl_filter(function(source)
        return source.name ~= "markdownlint-cli2"
      end, opts.sources or {})

      local nls = require("null-ls")
      local h = require("null-ls.helpers")
      local u = require("null-ls.utils")

      table.insert(
        opts.sources,
        nls.builtins.diagnostics.markdownlint_cli2.with({
          cwd = h.cache.by_bufnr(function(params)
            return u.root_pattern(
              ".markdownlint-cli2.jsonc",
              ".markdownlint-cli2.yaml",
              ".markdownlint-cli2.cjs",
              ".markdownlint-cli2.mjs",
              ".markdownlint.jsonc",
              ".markdownlint.json",
              ".markdownlint.yaml",
              ".markdownlint.yml",
              ".markdownlint.cjs",
              ".markdownlint.mjs"
            )(params.bufname)
          end),
        })
      )

      return opts
    end,
  },
  {
    [1] = "nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = vim.tbl_filter(function(linter)
        return linter ~= "markdownlint-cli2"
      end, opts.linters_by_ft.markdown or {})

      return opts
    end,
  },
}
