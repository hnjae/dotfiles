---@type LazySpec[]
return {
  {
    [1] = "none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      -- opts.sources = vim.tbl_filter(function(source)
      --   return source.name ~= "markdownlint-cli2"
      -- end, opts.sources or {})
      --
      -- local nls = require("null-ls")
      -- table.insert(opts.sources, nls. )

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
  {
    [1] = "conform.nvim",
    optional = true,
    opts = {
      formatters = {
        ["markdownlint-cli2"] = {
          condition = function(_, _)
            return true
          end,
        },
      },
    },
  },
}
