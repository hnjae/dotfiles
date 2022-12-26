local M = {}

function M.setup(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', vim.lsp.buf.formatting, {})
  -- vim.api.nvim_create_user_command('Format', vim.lsp.buf.formatting, {})
end

return M
