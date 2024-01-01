local M = {}

-- TODO: modifiable 이 off 일 때는 활성화 금지 <2023-12-28>

M.setup_lspconfig = function(lspconfig, opts)
  -- key: executable name / val: lspconfig's key
  local mapping = {
    ["marksman"] = "marksman",
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
    deno = {
      null_ls.builtins.formatting.deno_fmt.with({ filetypes = { "markdown" } }),
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

return M
