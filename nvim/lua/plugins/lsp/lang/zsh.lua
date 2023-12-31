local M = {}

M.get_null_ls_sources = function(null_ls)
  local ret = {}

  local mapping = {
    zsh = { null_ls.builtins.diagnostics.zsh },
    beautysh = { null_ls.builtins.formatting.beautysh.with({ filetypes = { "zsh" } }) },
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
