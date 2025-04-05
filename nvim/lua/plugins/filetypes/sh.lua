---@type LazySpec[]
return {
  {
    [1] = "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      require("plugins.core.treesitter.languages"):add("bash")
    end,
  },
  {
    -- :h conform-formatters
    -- https://github.com/stevearc/conform.nvim/tree/master/lua/conform/formatters
    [1] = "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      --[[
      NOTE:
        "shellharden": for 문 안의 $() to double quote 해버림
         beautysh: case 문 처리가 마음에 안듦. 과도한 indent
      ]]

      require("conform").formatters.shfmt = {
        prepend_args = function()
          if vim.bo.expandtab then
            return { "-i", tostring(vim.bo.shiftwidth) }
          end

          return {}
        end,
      }

      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.sh = {
        [1] = "shellcheck",
        [2] = "shfmt",
        stop_after_first = false,
      }
    end,
  },
  {
    [1] = "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        bashls = {
          ---@class LspconfigSetupOptsSpec
          settings = {},
        },
      },
    },
  },
  {
    [1] = "nvimtools/none-ls.nvim",
    optional = true,
    dependencies = {
      "gbprod/none-ls-shellcheck.nvim",
    },
    opts = function(_, opts)
      local null_ls = require("null-ls")

      local mapping = {
        printenv = {
          null_ls.builtins.hover.printenv,
        },
        -- NOTE: bashls 가 있어 shellcheck 는 deprecated 됨: https://github.com/nvimtools/none-ls.nvim/issues/58 <2024-03-06>
        shellcheck = {
          require("none-ls-shellcheck.diagnostics"),
          require("none-ls-shellcheck.code_actions"),
        },
      }

      for exe, sources in pairs(mapping) do
        if vim.fn.executable(exe) == 1 then
          vim.list_extend(opts.sources, sources)
        end
      end
    end,
  },
}
