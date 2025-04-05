local prefix = require("globals").prefix

---@type LazySpec
return {
  [1] = "shatur/neovim-session-manager",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  lazy = true,
  enabled = true,
  cond = not vim.g.vscode,
  cmd = {
    "SessionManager",
    "SessionLoad",
    "SessionSave",
    "SessionDelete",
  },
  opts = function()
    return {
      autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
      sessions_dir = require("plenary.path"):new(
        vim.fn.stdpath("data"),
        "session"
      ),
    }
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
      "SessionLoad",
      "SessionManager load_session",
      {}
    )
    vim.api.nvim_create_user_command(
      "SessionSave",
      "SessionManager save_current_session",
      {}
    )
    vim.api.nvim_create_user_command(
      "SessionDelete",
      "SessionManager delete_session",
      {}
    )
  end,
}
