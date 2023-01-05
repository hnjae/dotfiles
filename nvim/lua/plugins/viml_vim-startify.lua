-- exclude buffers from sessionoptions
-- vim.opt.sessionoptions = "blank,curdir,folds,help,tabpages,winsize"
-- minimap 문제 해결 안됨.

return {
  {
    'mhinz/vim-startify',
    lazy=false,
    config = function()
    -- vim.g.startify_session_dir = '~/.local/share/nvim/session' -- defaults

    -- Most Used Options:
    -- let g:startify_update_oldfiles = 1
    vim.g.startify_change_to_vcs_root = 1
    vim.g.startify_bookmarks = {
      '~/Sync/Library/wiki/index.adoc',
      '~/.config/ranger/',
      '~/.config/nvim/vim-include/',
    }
    vim.g.startify_lists = {
      { ['type'] = 'sessions', ['header'] = { '   Sessions' } },
      { ['type'] = 'bookmarks', ['header'] = { '   Bookmarks' } },
      { ['type'] = 'files', ['header'] = { '   MRU' } },
      { ['type'] = 'commands', ['header'] = { '   Commands' } },
    }
    vim.g.startify_custom_header = ''
    -- { ['type'] = 'dir',       ['header'] = { '   MRU ' .. vim.fn.getcwd() } },

    -- Misc Options:
    -- default: ASCII
    vim.g.startify_fortune_use_unicode = 1

    -- Sessions:
    vim.g.startify_session_persistence = 1
    vim.g.startify_session_autoload    = 1
    vim.g.startify_session_sort        = 1
    -- vim.g.startify_session_delete_buffers =1
    -- vim.g.startify_session_before_save = {
    --   'silent! tabdo MinimapClose'
    -- }
    -- vim.cmd([[
    --   let g:startify_session_before_save = [ 'silent! tabdo MinimapClose' ]
    -- ]])

    -- vim.g.startify_session_number      = 3
      end
  },
}
