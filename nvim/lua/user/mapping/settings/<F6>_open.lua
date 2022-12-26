local M = { }

local _OPEN_PREFIX = "<F6>"

function M.setup()
  local status_wk, wk = pcall(require, "which-key")
  if not status_wk then
    return
  end

  wk.register({ [_OPEN_PREFIX] = { name = "+open" } })

  if _IS_PLUGIN('vim-startify') then
    -- use s
    local keymap_startify = {
      name = "+startify",
      ["e"] = {"<cmd>Startify<CR>", "edit"},
      ["t"] = {"<cmd>tabnew<CR><cmd>Startify<CR>", "tab"},
      ["v"] = {"<cmd>vnew<CR><cmd>Startify<CR>", "vnew-vertical"},
      ["n"] = {"<cmd>new<CR><cmd>Startify<CR>", "new-horizontal"},
    }

    wk.register(keymap_startify, {prefix = _OPEN_PREFIX .. "s" })
  end



  --wk.register({ [_TAB_PREFIX] = { name = "+tab" } })
  --wk.register({ [_EDIT_PREFIX] = { name = "+edit" } })
  --wk.register({ [_WINDOW_PREFIX] = { name = "+window" } })

  ---------------------------------------------------
  ---- 공동
  ---------------------------------------------------
  ---- local file_parent = vim.fn.expand(('%:p:h'), false, false)
  --wk.register({
  --  -- ["n"] = { ":<C-u>edit .<CR>", "new" },
  --  ["n"] = { "<cmd>enew<CR>", "new" },
  --}, { prefix = _EDIT_PREFIX, mode = "n" }
  --)
  --wk.register({
  --  -- ["n"] = { ":<C-u>vnew .<CR>", "files" },
  --  ["n"] = { "<cmd>vnew<CR>", "new" },
  --}, { prefix = _WINDOW_PREFIX, mode = "n" }
  --)
  --wk.register({
  --  -- ["n"] = { ":<C-u>tabnew .<CR>", "files" },
  --  ["n"] = { "<cmd>tabnew<cR>", "new" },
  --}, { prefix = _TAB_PREFIX, mode = "n" }
  --)

  --if _IS_PLUGIN('vim-startify') then
  --  vim.api.nvim_set_keymap("n", _EDIT_PREFIX .. "s", ":<C-uStartify<CR>", {})
  --  wk.register({ ["s"] = "startify" }, { prefix = _EDIT_PREFIX })

  --  vim.api.nvim_set_keymap("n", _TAB_PREFIX .. "s", ":<C-u>tabnew<CR>:Startify<CR>", {})
  --  wk.register({ ["s"] = "startify" }, { prefix = _TAB_PREFIX })

  --  vim.api.nvim_set_keymap("n", _WINDOW_PREFIX .. "s", ":<C-u>vnew<CR>:Startify<CR>", {})
  --  wk.register({ ["s"] = "startify" }, { prefix = _WINDOW_PREFIX })
  --end

  --if _IS_PLUGIN('vimwiki') then
  --  wk.register({
  --    ["w"] = {name = "+wiki"},
  --    ["wi"] = { "<plug>VimwikiIndex", "index" },
  --    -- ["ws"] = { "<plug>VimwikiUISelect", "select" },
  --    ["wd"] = { "<plug>VimwikiDiaryIndex", "diary-index" },
  --    ["m"]  = {name = "+make-wiki-diary"},
  --    ["mt"] = { "<plug>VimwikiMakeDiaryNote", "today-diary-note" },
  --    ["my"] = { "<plug>VimwikiMakeYesterdayDiaryNote", "yesterday-diary-note" },
  --    ["mm"] = { "<plug>VimwikiMakeTomorrowDiaryNote", "tommorow-diary-note" },
  --  },
  --    { prefix = _EDIT_PREFIX, mode = 'n' }
  --  )

  --  wk.register({
  --    ["w"] = {name = "+wiki"},
  --    ["wi"]  = { "<plug>VimwikiTabIndex", "wiki-index" },
  --    -- ["ws"] = { "<plug>VimwikiUISelect", "select" },
  --    ["wd"]  = { ":<C-u>tabnew<CR>:VimwikiDiaryIndex<CR>", "diary-index" },
  --    ["m"]  = {name = "+make-wiki-diary"},
  --    ["mt"] = { "<plug>VimwikiTabMakeDiaryNote", "diary-note" },
  --    ["my"] = { ":<C-u>tabnew<CR>:VimwikiMakeYesterdayDiaryNote", "yesterday-diary-note" },
  --    ["mm"] = { ":<C-u>tabnew<CR>:VimwikiMakeTomorrowDiaryNote", "tommorow-diary-note" },
  --  },
  --    { prefix = _TAB_PREFIX, mode = 'n' }
  --  )

  --  wk.register({
  --    ["w"] = {name = "+wiki"},
  --    ["wi"]  = { ":<C-u>vnew<CR>:VimwikiIndex<CR>", "wiki-index" },
  --    ["dd"]  = { ":<C-u>vnew<CR>:VimwikiDiaryIndex<CR>", "diary-index" },
  --    -- ["ws"] = { "<plug>VimwikiUISelect", "select" },
  --    ["m"]  = {name = "+make-wiki-diary"},
  --    ["mt"] = { ":<C-u>vnew<CR>:VimwikiMakeDiaryNote", "diary-note" },
  --    ["my"] = { ":<C-u>vnew<CR>:VimwikiMakeYesterdayDiaryNote", "yesterday-diary-note" },
  --    ["mm"] = { ":<C-u>vnew<CR>:VimwikiMakeTomorrowDiaryNote", "tommorow-diary-note" },
  --  },
  --    { prefix = _WINDOW_PREFIX, mode = 'n' }
  --  )
  --end

  --if _IS_PLUGIN('fzf.vim') then
  --  -- local file_parent = vim.fn.expand(('%:p:h'), false, false)
  --  -- _EDIT_FILE = function()
  --    -- local file_parent = vim.fn.expand('%:p:h')
  --    -- vim.cmd("Files " .. file_parent .. "<CR>")
  --    -- vim.cmd("FZF")
  --  -- end
  --  wk.register(
  --    -- { ["f"] = { ":<C-u>FZF<CR>", "files" },},
  --    -- { ["f"] = { "<cmd>Files" .. vim.fn.expand('%:p:h') .. "<CR>", "files" }, },
  --    { ["f"] = { "<cmd>Files<CR>", "files" }, },
  --    -- { ["f"] = { "<cmd>lua _EDIT_FILE<CR>", "files" }, },
  --    { prefix = _EDIT_PREFIX, mode = "n" }
  --  )
  --  wk.register(
  --    -- { ["f"] = { ":<C-u>vnew<CR>:Files" .. vim.fn.expand('%:p:h') .. "<CR>", "files" }, },
  --    -- { ["f"] = { ":<C-u>vnew<CR>:Files .<CR>", "files" }, },
  --    { ["f"] = { ":<C-u>vnew<CR>:Files<CR>", "files" }, },
  --    { prefix = _WINDOW_PREFIX, mode = "n" }
  --  )
  --  wk.register({
  --    -- ["f"] = { ":<C-u>tabnew<CR>:Files" .. vim.fn.expand('%:p:h') .. "<CR>", "files" },
  --    ["f"] = { ":<C-u>tabnew<CR>:Files<CR>", "files" },
  --  }, { prefix = _TAB_PREFIX, mode = "n" }
  --  )
  --else
  --end
end

return M
