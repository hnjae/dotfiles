local M = {}

M.get_null_ls_sources = function(null_ls)
  local ret = {}

  local mapping = {
    -- fish
    fish = { null_ls.builtins.diagnostics.fish },
    fish_indent = { null_ls.builtins.formatting.fish_indent },
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
