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

M.get_null_ls_sources = function(null_ls, _)
  local ret = {}

  local fts = { "json", "jsonc" }
  local opts = { filetypes = fts }
  local formatter = {
    -- 우선 순위 높음
    { "prettier", null_ls.builtins.formatting.prettier.with(opts) },
    { "prettierd", null_ls.builtins.formatting.prettierd.with(opts) },
    { "deno", null_ls.builtins.formatting.deno_fmt.with(opts) },
    -- 우선 순위 낮음
  }
  for _, source in pairs(formatter) do
    if vim.fn.executable(source[1]) == 1 then
      table.insert(ret, source[2])
      break
    end
  end

  return ret
end

return M
