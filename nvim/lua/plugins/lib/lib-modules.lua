-- modules sourced by several plugins

---@type LazySpec[]
return {
  {
    [1] = "nvim-tree/nvim-web-devicons",
    lazy = true,
    cond = require("utils").enable_icon,
    opts = {
      default = true,
      override = {
        -- default_icon =
      },
      override_by_filename = {},
      override_by_extension = {},
    },
  },
  {
    [1] = "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    [1] = "kkharji/sqlite.lua",
    lazy = true,
    enabled = vim.fn.executable("sqlite3") == 1,
  },
  {
    [1] = "MunifTanjim/nui.nvim",
    lazy = true,
  },
}
