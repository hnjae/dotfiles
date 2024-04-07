---@type LspSpec
local M = {}

M.get_null_ls_sources = function(null_ls, _)
  local ret = {}

  local mapping = {
    ["editorconfig-checker"] = {
      null_ls.builtins.diagnostics.editorconfig_checker.with({
        filetypes = { "editorconfig" },
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
