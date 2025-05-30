return function(modules)
  local LSPActive = {
    condition = modules.conditions.lsp_attached,
    update = { "LspAttach", "LspDetach" },

    -- You can keep it simple,
    -- provider = " [LSP]",

    -- Or complicate things a bit and get the servers names
    provider = function()
      local names = {}
      for i, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
        table.insert(names, server.name)
      end
      return " [" .. table.concat(names, " ") .. "]"
    end,
    hl = { fg = "green", bold = true },
  }
  return LSPActive
end
