-- $XDG_CONFIG_HOME/nvim/init.lua

-- vim.lsp.set_log_level("trace")

require("config.options").setup()
require("config.keymaps").setup()
require("config.lazy").setup()
require("config.commands").setup()
require("config.autocmds").setup()

-- require("event-test").setup()
