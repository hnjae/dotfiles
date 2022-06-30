-- $XDG_CONFIG_HOME/nvim/init.lua

require('user.builtin').setup()
local packer_startup =  require('user.plugins')
vim.cmd('source ' .. _PACKER_COMPILED)
-- vim.cmd('source ' .. packer_startup.config.compile_path)
require('user.global-var')
require('user.lsp-setup').setup()
require('user.set-plugin').setup()
require('user.mapping').setup()
require('user.autocmd').setup()
-- if vim.fn.has('mac') == 1 then
--   require("mac-ime-switcher").setup()
-- end

local paths = vim.fn.uniq(
  vim.fn.sort(
    vim.fn.globpath(
      vim.o.runtimepath,
      'vim-include/*.[lv][ui][am]',
      false,
      true
    )
  )
)

for _, file in pairs(paths) do
  vim.cmd('source ' .. file)
end
