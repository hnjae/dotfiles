local M = {}

M.get_null_ls_sources = function(null_ls)
  local ret = {}

  local mapping = {
    -- prettier = {
      -- null_ls.builtins.formatting.prettier.with({ filetypes = { "html" } }),
      -- null_ls.builtins.range_formatting.prettier.with({ filetypes = { "html" } }),
    -- },
    tidy = {
      null_ls.builtins.formatting.tidy.with({ filetypes = { "html" } }),
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
