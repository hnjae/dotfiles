---@type LspSpec
local M = {}

M.get_null_ls_sources = function(null_ls)
  local ret = {}

  local mapping = {
    printenv = {
      null_ls.builtins.hover.printenv,
    },
    shellcheck = {
      null_ls.builtins.code_actions.shellcheck,
      null_ls.builtins.diagnostics.shellcheck,
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

M.get_conform_opts = function()
  return {
    formatters_by_ft = {
      sh = { "shfmt" },
    },
  }
end

return M
