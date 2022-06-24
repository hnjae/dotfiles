local M = {}
-- vim.cmd([[command! -nargs=0 Format lua vim.lsp.buf.formatting()<CR>]])

function M.setup()
  vim.api.nvim_create_user_command('Format', vim.lsp.buf.formatting, {})
end

return M
