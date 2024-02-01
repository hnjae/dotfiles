local M = {}

M.setup_lspconfig = function(lspconfig, opts)
  -- key: executable name / val: lspconfig's key
  local mapping = {
    -- refactor, etc
    ["jedi-language-server"] = "jedi_language_server",
    -- linter
    ["ruff-lsp"] = "ruff_lsp",
    --
    -- ["pylsp"] = "pylsp",
    -- a static type checker
    -- ["pyright-langserver"] = "pyright",
    --
  }

  for exe, lspname in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      lspconfig[lspname].setup(opts)
    end
  end
end

M.get_null_ls_sources = function(null_ls, null_ls_utils)
  local ret = {}

  -- key: executable, val: null_ls's source
  local mapping = {
    -- a static analysis tool for checking compliance with Python docstring conventions.
    -- pydocstyle = { null_ls.builtins.diagnostics.pydocstyle },
    mypy = { -- static typing checker
      null_ls.builtins.diagnostics.mypy.with({
        -- diagnostics_format = "[#{s}] #{m}",
        diagnostics_postprocess = function(diagnostic)
          diagnostic.message = "["
            .. diagnostic.source
            .. "] "
            .. diagnostic.message

          -- dirty hacks
          local ignore_msg =
            "module is installed, but missing library stubs or py.typed marker"
          if diagnostic.message:match(ignore_msg .. "$") then
            diagnostic.severity = vim.diagnostic.severity.HINT
          end
        end,

        -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1208
        runtime_condition = function(params)
          return null_ls_utils.path.exists(params.bufname)
        end,
      }),
    },
  }

  for exe, sources in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      for _, source in pairs(sources) do
        table.insert(ret, source)
      end
    end
  end

  return ret
end

M.conform = function()
  return {
    formatters_by_ft = {
      python = { "black", "isort" },
    },
  }
end

return M
