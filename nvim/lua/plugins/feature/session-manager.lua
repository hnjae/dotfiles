local prefix = require("val").prefix

---@type LazySpec
return {
  {
    [1] = "shatur/neovim-session-manager",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- to use telescope's vim.ui.select() UI
      {
        [1] = "nvim-telescope/telescope.nvim",
        optional = true,
      },
    },
    lazy = true,
    cmd = {
      "SessionManager",
      "Sload",
      "Ssave",
      "Sdelete",
    },
    opts = function()
      local opts = {
        autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
        sessions_dir = require("plenary.path"):new(
          vim.fn.stdpath("data"),
          "session"
        ),
      }
      return opts
    end,
    ---@type LazyKeysSpec[]
    keys = {
      {
        [1] = prefix.close .. "l",
        [2] = "SessionManager load_session",
        desc = "session-load",
      },
    },
    config = function(_, opts)
      require("session_manager").setup(opts)

      vim.api.nvim_create_user_command(
        "Sload",
        "SessionManager load_session",
        {}
      )
      vim.api.nvim_create_user_command(
        "Ssave",
        "SessionManager save_current_session",
        {}
      )
      vim.api.nvim_create_user_command(
        "Sdelete",
        "SessionManager delete_session",
        {}
      )
    end,
  },
}
