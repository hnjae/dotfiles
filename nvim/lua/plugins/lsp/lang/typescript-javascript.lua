---@type LspSpec
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

M.get_null_ls_sources = function(null_ls, _)
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

  for exe, sources in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      for _, source in pairs(sources) do
        table.insert(ret, source)
      end
    end
  end

  return ret
end

M.get_conform_opts = function()
  return {
    formatters_by_ft = {
      typescript = { { "prettierd", "prettier" } },
      javascript = { { "prettierd", "prettier" } },
    },
  }
end

return M
