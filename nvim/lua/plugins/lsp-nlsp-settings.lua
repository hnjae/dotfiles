return {
  "tamago324/nlsp-settings.nvim",
  dependencies = {
    -- "rcarriga/nvim-notify", -- optional
    "folke/neodev.nvim",
  },
  opts = {
    config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
    local_settings_dir = ".nlsp-settings",
    local_settings_root_markers_fallback = { ".git" },
    append_default_schemas = false,
    loader = "yaml",
  },
  config = function(_, opts)
    require("nlspsettings").setup(opts)
    -- use LspSettings instead
    vim.api.nvim_del_user_command("NlspConfig")
    vim.api.nvim_del_user_command("NlspBufConfig")
    vim.api.nvim_del_user_command("NlspLocalConfig")
    vim.api.nvim_del_user_command("NlspLocalBufConfig")
    vim.api.nvim_del_user_command("NlspUpdateSettings")
  end,
}
