---@type LspSpec
local M = {}

M.setup_lspconfig = function(lspconfig, opts)
  -- key: executable name / val: lspconfig's key
  local mapping = {
    ["lua-language-server"] = "lua_ls",
  }

  for exe, lspname in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      lspconfig[lspname].setup(opts)
    end
  end
end

M.get_null_ls_sources = function(null_ls)
  local ret = {}

  local mapping = {
    selene = { null_ls.builtins.diagnostics.selene }, -- lua linter written in rust
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
    -- stylua:  lua formatter written in rust
    formatters_by_ft = {
      lua = { "stylua" },
    },
  }
end

return M
