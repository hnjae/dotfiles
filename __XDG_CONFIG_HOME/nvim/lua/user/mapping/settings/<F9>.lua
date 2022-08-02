local M = { }

local _PREFIX = "<F9>"

M.setup = function ()
  local status_wk, wk = pcall(require, "which-key")
  if not status_wk then
    return
  end

  vim.cmd([[
  nmap <F9> <Esc><C-w>w
  vmap <F9> <Esc><C-w>w
  omap <F9> <Esc><C-w>w
  tmap <F9> <Esc><C-w>w
  imap <F9> <Esc><C-w>w
  ]]
  )

  -- wk.register(
  --   {
  --     ["<F12>"] = {'"+y', "copy-to-clipboard"},
  --     ["<Shift-F12>"] = {'"+p', "paste-from-clipboard"},
  --   }, {}
  -- )

  -- wk.register({ [_PREFIX] = { name = "+open" } })

  -- if _IS_PLUGIN('vim-startify') then
  --   -- use s
  --   local keymap_startify = {
  --     -- name = "+startify",
  --     ["e"] = {"<cmd>Startify<CR>", "edit"},
  --     ["t"] = {"<cmd>tabnew<CR><cmd>Startify<CR>", "tab"},
  --     ["v"] = {"<cmd>vnew<CR><cmd>Startify<CR>", "vnew-vertical"},
  --     ["n"] = {"<cmd>new<CR><cmd>Startify<CR>", "new-horizontal"},
  --   }

  --   -- wk.register(keymap_startify, {prefix = _PREFIX .. "s" })
  -- end
end


return M
