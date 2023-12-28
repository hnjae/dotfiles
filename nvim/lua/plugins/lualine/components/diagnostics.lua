return {
  [1] = "diagnostics",
  symbols = {
    error = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
    warn = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
    info = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
    hint = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
  },
}
