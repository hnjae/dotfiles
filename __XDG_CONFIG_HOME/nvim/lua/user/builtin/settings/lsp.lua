vim.lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, {
  border = "rounded"
})
vim.lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, {
  border = "rounded"
})
