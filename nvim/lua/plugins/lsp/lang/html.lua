local M = {}

M.setup_lspconfig = function(lspconfig, opts)
  -- key: executable name / val: lspconfig's key
  local mapping = {
    ["vscode-html-language-server"] = "html",
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
    -- prettier = {
    -- null_ls.builtins.formatting.prettier.with({ filetypes = { "html" } }),
    -- null_ls.builtins.range_formatting.prettier.with({ filetypes = { "html" } }),
    -- },

    -- NOTE: tidy is too verbose <2024-01-12>
    -- tidy = {
    -- null_ls.builtins.formatting.tidy.with({ filetypes = { "html" } }),
    -- null_ls.builtins.diagnostics.tidy.with({ filetypes = { "html" } }),
    -- },
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

M.conform = function()
  return {
    formatters_by_ft = {
      html = { { "prettierd", "prettier" } },
    },
  }
end

return M
