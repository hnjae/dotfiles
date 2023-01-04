-- $XDG_CONFIG_HOME/nvim/init.lua

require('user.builtin').setup()

-- NOTE: packer_startup: table
local is_packer, packer_startup = pcall(require, 'user.plugins')
if is_packer and packer_startup ~= 1 and vim.fn.filereadable(_PACKER_COMPILED) == 1 then
  vim.cmd('source ' .. _PACKER_COMPILED)
  -- vim.cmd('source ' .. packer_startup.config.compile_path)
end

require('user.global-var')

require('user.lsp').setup()
require('user.commands').setup()
require('user.autocmd').setup()
require('user.set-plugin').setup()
require('user.mapping').setup()


pp = function(arg)
  print(vim.inspect(aa))
end

-- vim.api.nvim_set_keymap("n", "<F6>", "print(vim.inspect(vim.fn.getpos('.')))", {})

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
--
-- for _, file in pairs(paths) do
--   vim.cmd('source ' .. file)
-- end
