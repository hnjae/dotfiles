---@type LazySpec[]
return {
  {
    [1] = "lazy.nvim",
    optional = true,
    opts = function()
      vim.g.lazyvim_python_lsp = "ty"
    end,
  },
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
        pyright = {
          enabled = false,
          mason = false,
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
}
