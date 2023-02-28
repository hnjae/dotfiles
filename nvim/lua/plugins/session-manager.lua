return {
  {
    "shatur/neovim-session-manager",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- to use telescope's vim.ui.select() UI
      "nvim-telescope/telescope.nvim",
    },
    lazy = true,
    cmd = {
      "SessionManager",
      "SSLoad",
      "SSSave",
      "SSDelete",
    },
    opts = function()
      local opts = {
        autoload_mode = require('session_manager.config').AutoloadMode.Disabled,
        sessions_dir = require('plenary.path'):new(vim.fn.stdpath('data'), 'session'),
      }
      return opts
    end,
    config = function(_, opts)
      require("session_manager").setup(opts)

      vim.api.nvim_create_user_command("SSLoad", "SessionManager load_session", {} )
      vim.api.nvim_create_user_command("SSSave", "SessionManager save_current_session", {} )
      vim.api.nvim_create_user_command("SSDelete", "SessionManager delete_session", {} )
    end
  },
}
