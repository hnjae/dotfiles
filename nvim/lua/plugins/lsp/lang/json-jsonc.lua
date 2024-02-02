---@type LspSpec
local M = {}

M.setup_lspconfig = function(lspconfig, opts)
  -- key: executable name / val: lspconfig's key
  local mapping = {
    ["vscode-json-language-server"] = "jsonls",
  }

  for exe, lspname in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      lspconfig[lspname].setup(opts)
    end
  end
end

M.get_conform_opts = function()
  return {
    formatters_by_ft = {
      json = { { "prettierd", "prettier", "deno" } },
      jsonc = { { "prettierd", "prettier", "deno" } },
    },
  }
end

return M
