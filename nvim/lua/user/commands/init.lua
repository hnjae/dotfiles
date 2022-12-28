local M = {}
M.setup = function()
  -- local table = {
  --   ["Format"] = ":call CocActionAsync('format')"
  -- }

  if _IS_PLUGIN("coc.nvim") then
    ----------------------------------------------------------------
    -- Add `:Fold` command to fold current buffer.
    ----------------------------------------------------------------
    vim.cmd([[
    command! -nargs=? Fold :call CocAction('fold', <f-args>)
    command! -nargs=0 Format :call CocActionAsync('format')
    command! -nargs=0 Organize :call CocActionAsync('runCommand', 'editor.action.organizeImport')
    ]])
  else
    -- vim.api.nvim_buf_create_user_command('Format', vim.lsp.buf.formatting, {})
    vim.api.nvim_create_user_command('Format', vim.lsp.buf.formatting, {})
  end
end
return M
