local M = {}


M.get_null_ls_sources = function(null_ls, _)
  local ret = {}

  local mapping = {
    deno = {
      null_ls.builtins.formatting.deno_fmt.with({
        filetypes = {"jsonc"},
      }),
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
