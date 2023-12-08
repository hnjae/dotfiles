local M = {}

M.setup_lspconfig = function(lspconfig, opts)
  -- key: executable name / val: lspconfig's key
  local mapping = {
    -- provides grammar and spelling errors in markup documents (LaTeX, Markdown, etc.). The documents are checked with LanguageTool.
    ["ltex-ls"] = "ltex",
  }

  for exe, lspname in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      lspconfig[lspname].setup(opts)
    end
  end
end

return M
