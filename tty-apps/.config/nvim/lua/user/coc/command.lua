-- EXTEND DEFAULT KEYMAP

local M = {}
M.setup = function ()
  ----------------------------------------------------------------
  -- Add `:Fold` command to fold current buffer.
  vim.cmd([[
  command! -nargs=? Fold :call CocAction('fold', <f-args>)
  command! -nargs=0 Format :call CocActionAsync('format')
  command! -nargs=0 Organize  :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
  ]])
end
return M
