local M = {}

M.setup_lspconfig = function(lspconfig, opts)
  require("buf-format-deny"):add("tsserver")
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
    -- eslint_d = {
    --   null_ls.builtins.diagnostics.eslint_d,
    --   null_ls.builtins.code_actions.eslint_d,
    --   -- null_ls.builtins.formatting.eslint_d,
    -- },
    eslint = {
      null_ls.builtins.code_actions.eslint,
      null_ls.builtins.diagnostics.eslint,
    },

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

  local opts = {
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
  }

  -- local formatter = {
  --   -- 우선 순위 높음
  --   { "prettier", null_ls.builtins.formatting.prettier.with(opts) },
  --   { "prettierd", null_ls.builtins.formatting.prettierd.with(opts) },
  --   { "deno", null_ls.builtins.formatting.deno_fmt.with(opts) },
  --   -- 우선 순위 낮음
  -- }
  -- for _, source in pairs(formatter) do
  --   if vim.fn.executable(source[1]) == 1 then
  --     table.insert(ret, source[2])
  --     break
  --   end
  -- end

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
      typescript = { { "prettierd", "prettier" } },
      javascript = { { "prettierd", "prettier" } },
    },
  }
end

return M
