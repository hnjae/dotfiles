return {
  "jose-elias-alvarez/null-ls.nvim",
  lazy = false,
  enabled = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "jay-babu/mason-null-ls.nvim",
      lazy = true,
      dependencies = {
        "williamboman/mason.nvim",
      },
      opts = {
        ensure_installed = {
          "ktlint",
          -- python
          "ruff",
          "black",
          -- "mypy",
          -- lua
          "selene",
          "stylua",
        },
      },
    },
  },
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/CONFIG.md
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
  opts = function()
    local null_ls = require("null-ls")
    local utils = require("null-ls.utils")

    -- local diagnostics_mypy = null_ls.builtins.diagnostics.mypy.with({
    --   diagnostics_format = "[#{s}] #{m}",
    --   -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1208
    --   -- cwd = function (_) return vim.fn.getcwd() end,
    --   -- https://github.com/python/mypy/issues/4746
    --   runtime_condition = function(params)
    --     return utils.path.exists(params.bufname)
    --   end,
    -- })

    local diagnostics_ruff = null_ls.builtins.diagnostics.ruff.with({
      diagnostics_postprocess = function(diagnostic)
        diagnostic.message = "[" .. diagnostic.code .. "] " .. diagnostic.message .. " (" .. diagnostic.source .. ")"
        local severity = diagnostic.severity
        if diagnostic.code == "E902" or diagnostic.code == "E999" then
          severity = vim.diagnostic.severity.ERROR
        else
          severity = vim.diagnostic.severity.WARN
          -- -- TODO: this is dirty <2023-01-27, Hyunjae Kim>
          -- local code_1 = diagnostic.code:sub(1, 1)
          -- if code_1 == "I" or code_1 == "Q" or diagnostic.code:sub(1, 3) == "COM" then
          --   severity = vim.diagnostic.severity.HINT
          -- else
          -- end
        end
        diagnostic.severity = severity
      end,
    })

    local opts = {
      debug = true,
      diagnostics_format = "#{m} (#{s})",
      -- diagnostics_format = "[#{c}] #{m} (#{s})",
      root_dir = require("null-ls.utils").root_pattern(
        unpack(require("val").root_patterns)
      ),
      sources = {
        -- null_ls.builtins.completion.spell,
        -- null_ls.builtins.completion.tags,
        -- null_ls.builtins.diagnostics.cspell,
        -- null_ls.builtins.diagnostics.eslint,
        -- null_ls.builtins.code_actions.cspell,

        -- kotlin
        null_ls.builtins.formatting.ktlint,
        null_ls.builtins.diagnostics.ktlint,

        -- "sh"
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.hover.printenv,
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.diagnostics.shellcheck,
        -- null_ls.builtins.diagnostics.dotenv_linter,
        -- null_ls.builtins.formatting.shellharden,

        -- zsh
        null_ls.builtins.diagnostics.zsh,
        null_ls.builtins.formatting.beautysh.with({ filetypes = { "zsh" } }),

        -- sqlfluff
        null_ls.builtins.diagnostics.sqlfluff,
        null_ls.builtins.formatting.sqlfluff,

        -- lua
        null_ls.builtins.diagnostics.selene,
        null_ls.builtins.formatting.stylua,

        -- python
        null_ls.builtins.formatting.ruff, -- sort imports
        null_ls.builtins.formatting.black, -- format code
        -- diagnostics_mypy,
        null_ls.builtins.diagnostics.mypy,
        diagnostics_ruff,
      },
    }

    return opts
  end,
}
