---@type LspSpec
local M = {}

M.get_null_ls_sources = function(null_ls, _)
  local ret = {}

  local mapping = {
    -- fish
    fish = { null_ls.builtins.diagnostics.fish },
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

M.get_conform_opts = function()
  return {
    formatters_by_ft = {
      fish = { "fish_indent" },
    },
  }
end
return M
