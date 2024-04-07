-- $XDG_CONFIG_HOME/nvim/init.lua

-- vim.lsp.set_log_level("trace")

require("user.builtin").setup()
require("setup-lazy").setup()

require("user.autocmd").setup()
require("setup-semi-plugins").setup()

-- require("event-test").setup()
