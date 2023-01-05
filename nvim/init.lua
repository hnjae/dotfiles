-- $XDG_CONFIG_HOME/nvim/init.lua

require('user.builtin').setup()

require('setup-lazy')
require('global-var')

require('user.lsp').setup()
require('user.commands').setup()
require('user.autocmd').setup()
require('user.mapping').setup()

-- local paths = vim.fn.uniq(
--   vim.fn.sort(
--     vim.fn.globpath(
--       vim.o.runtimepath,
--       'vim-include/*.[lv][ui][am]',
--       false,
--       true
--     )
--   )
-- )

local status_wk, wiki = pcall(require, "asciidoc-wiki")
if not status_wk then
  return
end

wiki.setup{
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
