local M = {}
local status_wk, wk = pcall(require, "which-key")

M.setup = function ()
  if not _IS_PLUGIN("vim-easymotion") then
    return
  end
  vim.cmd([[
  " <Leader>f{char} to move to {char}
  map  <Leader>f <Plug>(easymotion-bd-f)
  nmap <Leader>f <Plug>(easymotion-overwin-f)
  ]])
end
return M
