-- NOTE: use direnv to modify your PATH (layout node in .envrc) <2024-02-15>

---@type LspSpec
local M = {}

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

M.setup_lspconfig = function(lspconfig, opts)
  require("buf-format-deny"):add("tsserver")

  -- key: executable name / val: {lspconfig's key, opts}
  local mapping = {
    ["typescript-language-server"] = {
      "tsserver",
      opts,
    },

    ["vscode-eslint-language-server"] = {
      "eslint",
      vim.tbl_deep_extend("force", opts, {
        -- https://eslint.org/docs/latest/use/configure/configuration-files#configuration-file-formats
        root_dir = lspconfig.util.root_pattern(unpack({
          "eslint.config.js",
          "eslint.config.mjs",
          "eslint.config.cjs",
          ".eslintrc.js",
          ".eslintrc.cjs",
          ".eslintrc.yaml",
          ".eslintrc.yml",
          ".eslintrc.json",
          "package.json",
        })),
      }),
    },
    ["tailwindcss-language-server"] = { "tailwindcss", opts },

    ["vscode-json-language-server"] = { "jsonls", opts },
    ["vscode-css-language-server"] = { "cssls", opts },
    ["vscode-html-language-server"] = { "html", opts },

    -- ["vscode-markdown-language-server"] = "",
  }
  for exe, obj in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      lspconfig[obj[1]].setup(obj[2])
    end
  end

  -- if
  --   vim.fn.executable("vscode-eslint-language-server") ~= 1
  --   and vim.fn.executable("deno") == 1
  -- then
  --   lspconfig["denols"].setup(opts)
  -- end
end

M.get_conform_opts = function()
  local formatter = { "prettierd", "prettier", "deno_fmt" }
  local formatter_prettier = { "prettierd", "prettier" }
  return {
    formatters_by_ft = {
      typescript = { formatter },
      javascript = { formatter },
      typescriptreact = { formatter },
      javascriptreact = { formatter },
      json = { formatter },
      jsonc = { formatter },
      html = { formatter_prettier },
      vue = { formatter_prettier },
      css = { formatter_prettier },
      scss = { formatter_prettier },
      lss = { formatter_prettier },
      graphql = { formatter_prettier },
      handlebars = { formatter_prettier },
      ["markdown.mdx"] = { formatter_prettier },
      -- yaml, markdown
    },
  }
end

return M
