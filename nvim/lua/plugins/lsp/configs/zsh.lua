---@type LspSpec
local M = {}

M.get_null_ls_sources = function(null_ls)
  local ret = {}

  local mapping = {
    zsh = { null_ls.builtins.diagnostics.zsh },
    shellcheck = {
      require("none-ls-shellcheck.diagnostics").with({ filetypes = { "zsh" } }),
      require("none-ls-shellcheck.code_actions").with({ filetypes = { "zsh" } }),
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
      zsh = { "shellcheck", "beautysh" },
    },
  }
end

return M
