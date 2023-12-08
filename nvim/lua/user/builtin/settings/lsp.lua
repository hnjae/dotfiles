local lsp = vim.lsp

lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, { border = "rounded" })
lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, { border = "rounded" })

vim.api.nvim_create_user_command("Format", function()
  vim.lsp.buf.format({ async = false })
end, {})
