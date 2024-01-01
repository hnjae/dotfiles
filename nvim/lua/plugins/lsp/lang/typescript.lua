local M = {}

M.setup_lspconfig = function(lspconfig, opts)
  -- key: executable name / val: lspconfig's key
  local mapping = {
    ["typescript-language-server"] = "tsserver",
  }
  for exe, lspname in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      lspconfig[lspname].setup(opts)
    end
  end
end

M.get_null_ls_sources = function(null_ls, null_ls_utils)
  local ret = {}

  local mapping = {
    eslint_d = {
      null_ls.builtins.diagnostics.eslint_d,
      null_ls.builtins.code_actions.eslint_d,
      -- null_ls.builtins.formatting.eslint_d,
    },
    -- eslint = {
    --   null_ls.builtins.code_actions.eslint.with({}),
    --   null_ls.builtins.diagnostics.eslint.with({}),
    -- },

    -- NOTE: Using prettier with linters
    -- https://prettier.io/docs/en/integrating-with-linters.html
    --[[
    requires:
    `npm install --save-dev eslint-config-prettier`

    ```
    {
      "extends": [
        "some-other-config-you-use",
        "prettier"
      ]
    }
    ```
    ]]
  }

  local formatter = {
    -- prettierd: prettier as daemon
    prettierd = {
      null_ls.builtins.formatting.prettierd.with({
        filetypes = { "typescript" },
      }),
    },
    prettier = {
      null_ls.builtins.formatting.prettierd.with({
        filetypes = { "typescript" },
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

  for exe, sources in pairs(formatter) do
    if vim.fn.executable(exe) == 1 then
      for _, source in pairs(sources) do
        table.insert(ret, source)
      end
      break
    end
  end

  return ret
end

return M
