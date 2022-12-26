local M = {}

M.setup = function ()
  vim.cmd([[
  autocmd CursorHold * silent call CocActionAsync('highlight')
  ]])


  -- test
  local keyset = vim.keymap.set
  -- Auto complete
  function _G.check_back_space()
      local col = vim.fn.col('.') - 1
      return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
  end


end


return M
