-- $XDG_CONFIG_HOME/nvim/init.lua

require("user.builtin").setup()

require("setup-lazy").setup()

require("user.autocmd").setup()
require("setup-semi-plugins").setup()

-- require("test")

-- vim.cmd([[
--   " set foldlevel=20
--   set nofoldenable
-- ]])
--
