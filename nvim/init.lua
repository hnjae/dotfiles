-- $XDG_CONFIG_HOME/nvim/init.lua

require('global-var')
require('user.builtin').setup()

require('setup-lazy')

require('user.autocmd').setup()

local status_wk, wiki = pcall(require, "asciidoc-wiki")
if status_wk then
  wiki.setup {
    wiki_list = {
      {
        path = "~/Sync/Library/wiki",
      },
      {
        path = "~/Sync/Library/hnjae.github.io/content/posts",
      },
    },
    conceal_links = true,
    key_mappings = { prefix = "s" },
  }
end

vim.keymap.set('n', '<F4>', "<cmd>Lazy<CR>", {})
-- vim.keymap.set('n', '<leader>w', function() print("blabla") end, {desc="blabla2"})
