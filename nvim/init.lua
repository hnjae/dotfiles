-- $XDG_CONFIG_HOME/nvim/init.lua

require("config.options").setup()
require("config.keymaps").setup()
require("plugins.lazy").setup()
require("config.commands").setup()
require("config.autocmds").setup()

-- require("event-test").setup()
