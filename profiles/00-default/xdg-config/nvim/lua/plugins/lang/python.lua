---@type LazySpec[]
return {
  {
    [1] = "nvim-lspconfig",
    optional = true,
    -- ---@type lspconfig.options
    opts = {
      servers = {
        ty = {
          mason = false,
        },
        basedpyright = {
          enabled = false,
          mason = false, -- mason 이 venv 안에 설치하는데, 이것이 이슈가 있음. <2025-05-07>
        },
      },
    },
  },
  {
    [1] = "conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = {
          -- "ruff_fix"
          [1] = "ruff_organize_imports",
          [2] = "ruff_format",
          stop_after_first = false,
        },
      },
    },
    specs = {
      {
        [1] = "mason.nvim",
        optional = true,
        opts = { ensure_installed = { "ruff" } },
      },
    },
  },
  -- NOTE: nvim-lint does not handle cwd
  {
    [1] = "none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      -- DO NOT USE mason.nvim since `mypy` requires to read library stub

      -- if vim.fn.executable("mypy") == 1 then
      --   local nls = require("null-ls")
      --
      --   opts.sources = vim.list_extend(opts.sources or {}, {
      --     nls.builtins.diagnostics.mypy,
      --   })
      -- end
    end,
  },
}
