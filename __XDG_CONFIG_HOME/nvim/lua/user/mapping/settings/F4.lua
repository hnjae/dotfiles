local M = {}


function M.setup()
  local status_wk, wk = pcall(require, "which-key")
  if not status_wk then
    return
  end

  -- vim.cmd([[
  -- nmap <F4> <C-\><C-n>
  -- vmap <F4> <C-\><C-n>
  -- omap <F4> <C-\><C-n>
  -- xmap <F4> <C-\><C-n>
  -- smap <F4> <C-\><C-n>
  -- imap <F4> <C-\><C-n>
  -- lmap <F4> <C-\><C-n>
  -- cmap <F4> <C-\><C-n>
  -- tmap <F4> <C-\><C-n>
  -- ]])

  -- vim.api.nvim_set_keymap("v", "<F4>", "<C-\\><C-n>", {})


end

return M
