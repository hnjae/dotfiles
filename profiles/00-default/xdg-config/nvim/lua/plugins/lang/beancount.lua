--[[

NOTE: 2025-10-19

  - `bean-check` 나 `bean-format` 은 `beancount` 패키지에 포함되어 있다.
  -- beancount-language-server 가 bean-check 를 수행함.
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
          -- 빌드에 cargo 필요, rustc 버전 mismatch 발생. 2026-01-13
          mason = false,
          enabled = vim.fn.executable("beancount-language-server") == 1,
          init_options = {
            journal_file = os.getenv("HOME") .. "/Projects/my-ledger/main.beancount",
          },
        },
      },
    },
  },
}
