local M = { }

local _PREFIX = "<F12>"

M.setup = function ()
  local status_wk, wk = pcall(require, "which-key")
  if not status_wk then
    return
  end

  vim.cmd([[
  nmap <F12> "+y
  vmap <F12> "+y
  nmap <S-F12> "+p
  vmap <S-F12> "+p
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
