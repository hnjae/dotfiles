-- exclude buffers from sessionoptions
-- vim.opt.sessionoptions = "blank,curdir,folds,help,tabpages,winsize"
-- minimap 문제 해결 안됨.

return {
  {
    'mhinz/vim-startify',
    lazy = false,
    dependencies = { "folke/which-key.nvim" },
    config = function()
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

      -- Misc Options:
      -- default: ASCII
      vim.g.startify_fortune_use_unicode = 1

      -- Sessions:
      vim.g.startify_session_persistence = 1
      vim.g.startify_session_autoload    = 1
      vim.g.startify_session_sort        = 1

      --------------------------------------------------------------------------
      -- key-mapping
      --------------------------------------------------------------------------
      local keymap_startify = {
        name = "+startify",
        ["e"] = { "<cmd>Startify<CR>", "edit" },
        ["t"] = { "<cmd>tabnew<CR><cmd>Startify<CR>", "tab" },
        ["v"] = { "<cmd>vnew<CR><cmd>Startify<CR>", "vnew-vertical" },
        ["h"] = { "<cmd>new<CR><cmd>Startify<CR>", "new-horizontal" },
      }
      require("which-key").register(
        keymap_startify, { prefix = _MAPPING_PREFIX["open"] .. "s" }
      )
    end
  },
}
