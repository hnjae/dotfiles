local M = {}

function M.setup()
  local module_list = {
    'user.mapping.extend-defaults',
    'user.mapping.sidebar',
    'user.mapping.l_-fzf',
    'user.mapping.telescope',
    'user.mapping.open',
    'user.mapping.F1-help',
    'user.mapping.F3-telescope',
    'user.mapping.F2-C-w',
    'user.mapping.C-tilda',
    'user.mapping.vimspector',
    'user.mapping.vim-easymotion',
  }

  for _, module_name in ipairs(module_list) do
    local status, module = pcall(require, module_name)
    if status then
      module.setup()
    end
  end
end

  -- require('user.mapping.extend-defaults').setup()
  -- -- require('user.mapping.edit-tab-window-sidebar')
  -- require('leader_s-sidebar.lua').setup()
  -- require('user.mapping.search').setup()
  -- require('user.mapping.telescope').setup()
  -- require('user.mapping.f1-help').setup()

return M
