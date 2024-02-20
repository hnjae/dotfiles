-- NOTE: use direnv to modify your PATH <2024-02-15>
---@type LspSpec
local M = {}

-- NOTE: 버퍼에 파일을 따로 안열어도 잘 작동 <2024-02-14>
-- local project_root = require("plenary.path"):new(
--   (
--     require("lspconfig").util.root_pattern(unpack(root_patterns))(
--       vim.fn.expand("%:p:h")
--     )
--   )
-- )

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

  local root_patterns = {
    "package.json",
    "pnpm-lock.yaml",
  }

  -- nil if project_root not found
  local project_root = require("lspconfig").util.root_pattern(
    unpack(root_patterns)
  )(vim.fn.expand("%:p:h"))

  if project_root == nil then
    return {}
  end

  local mapping = {
    xo = {
      null_ls.builtins.code_actions.xo,
      null_ls.builtins.diagnostics.xo,
    },
    eslint = {
      null_ls.builtins.code_actions.eslint,
      null_ls.builtins.diagnostics.eslint,
    },
    -- eslint_d = {
    --   null_ls.builtins.diagnostics.eslint_d,
    --   null_ls.builtins.code_actions.eslint_d,
    -- },
  }

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

  for exe, sources in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      for _, source in pairs(sources) do
        table.insert(ret, source)
      end
      break
    end
  end

  return ret
end

M.get_conform_opts = function()
  return {
    formatters_by_ft = {
      typescript = { { "prettier", "prettierd" } },
      javascript = { { "prettier", "prettierd" } },
    },
  }
end

return M
