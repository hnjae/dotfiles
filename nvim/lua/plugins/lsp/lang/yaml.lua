local M = {}

M.setup_lspconfig = function(lspconfig, opts)
  -- key: executable name / val: lspconfig's key

  local mapping = {
    -- https://github.com/redhat-developer/yaml-language-server
    ["yaml-language-server"] = "yamlls",
  }

  for exe, lspname in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      lspconfig[lspname].setup(opts)
    end
  end
end

M.get_null_ls_sources = function(null_ls, null_ls_utils)
  local ret = {}

  local formatter = {
    prettierd = {
      null_ls.builtins.formatting.prettierd.with({ filetypes = { "yaml" } }),
    },
    prettier = {
      null_ls.builtins.formatting.prettier.with({ filetypes = { "yaml" } }),
    },
  }

  for exe, sources in pairs(formatter) do
    if vim.fn.executable(exe) == 1 then
      for _, source in pairs(sources) do
        table.insert(ret, source)
      end
      break
    end
  end

  return ret
end

return M
