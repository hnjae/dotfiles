-- EXTEND DEFAULT KEYMAP

local M = {}
M.setup = function ()
  ----------------------------------------------------------------
  -- Add `:Fold` command to fold current buffer.
  vim.cmd([[
  command! -nargs=? Fold :call CocAction('fold', <f-args>)
  ]])
  ----------------------------------------------------------------
end
return M