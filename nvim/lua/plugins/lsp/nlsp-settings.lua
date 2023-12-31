return {
  [1] = "tamago324/nlsp-settings.nvim",
  lazy = true,
  -- commit = "3cdc23e302d6283d294f42ef5b57edb6dc9b6c5e",
  dependencies = {
    -- "rcarriga/nvim-notify", -- optional
    "folke/neodev.nvim",
  },
  opts = {
    config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
    local_settings_dir = ".nlsp-settings",
    local_settings_root_markers_fallback = require("val").root_patterns,
    append_default_schemas = true,
    loader = "yaml",
    nvim_notify = { enable = true },
  },
  main = "nlspsettings",
  config = function(_, opts)
    require("nlspsettings").setup(opts)

    -- local deprecated_commands = {
    --   "NlspBufConfig",
    --   "NlspLocalBufConfig",
    -- }
    -- for _, command in pairs(deprecated_commands) do
    --   vim.api.nvim_del_user_command(command)
    -- end
  end,
}
