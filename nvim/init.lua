-- $XDG_CONFIG_HOME/nvim/init.lua

require('user.builtin').setup()

require('plugins').setup()
vim.cmd([[colorscheme vscode]])

require('global-var')

require('user.lsp').setup()
require('user.commands').setup()
require('user.autocmd').setup()
require('user.set-plugin').setup()
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
