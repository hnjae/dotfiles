-- $XDG_CONFIG_HOME/nvim/init.lua

require('user.builtin').setup()

-- NOTE: packer_startup: table
is_packer, packer_startup = pcall(require, 'user.plugins')
if is_packer and packer_startup ~= 1 and vim.fn.filereadable(_PACKER_COMPILED) == 1 then
  vim.cmd('source ' .. _PACKER_COMPILED)
  -- vim.cmd('source ' .. packer_startup.config.compile_path)
end

require('user.global-var')

if _IS_PLUGIN("coc.nvim") then
  require('user.coc').setup()
else
  require('user.lsp-setup').setup()
end
require('user.set-plugin').setup()
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
--
-- for _, file in pairs(paths) do
--   vim.cmd('source ' .. file)
-- end
