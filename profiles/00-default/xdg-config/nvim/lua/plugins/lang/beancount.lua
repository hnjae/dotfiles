--[[

NOTE: 2025-10-19

  - `bean-check` 나 `bean-format` 은 `beancount` 패키지에 포함되어 있다.
]]

---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "beancount" } },
  },
  {
    [1] = "conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      if vim.fn.executable("bean-format") == 1 then
        opts.formatters_by_ft.beancount = { "bean-format" }
      end
    end,
  },
  {
    [1] = "nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        beancount = {
          enabled = true,
        },
      },
    },
    specs = {
      {
        [1] = "mason.nvim",
        optional = true,
        opts = { ensure_installed = { "beancount-language-server" } },
      },
    },
  },
  {
    [1] = "none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")

      if vim.fn.executable("bean-check") == 1 then
        opts.sources = vim.list_extend(opts.sources or {}, {
          nls.builtins.diagnostics.bean_check,
        })
      end
    end,
  },
}
