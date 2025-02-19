local val = require("val")
local icons = val.icons
local utils = require("utils")

return {
  [1] = "TimUntersberger/neogit",
  enabled = true,
  lazy = true,
  cmd = {
    "Neogit",
    "NeogitResetState",
    "NeogitCommit",
    "NeogitLog",
  },
  opts = {
    notification_icon = utils.enable_icon and icons.git or "G",
    graph_style = utils.enable_icon and "unicode" or "ascii",
    disable_line_numbers = false,
    disable_relative_line_numbers = false,

    mappings = {
      -- popup = {
      --   ["Z"] = nil,
      --   ["z"] = "StashPopup",
      -- },
    },
  },
  keys = {
    {
      [1] = val.prefix.git .. val.map_keyword.git,
      [2] = "<cmd>Neogit<CR>",
      desc = "open-neogit",
    },
    {
      [1] = val.prefix.git .. "c",
      [2] = "<cmd>Neogit commit<CR>",
      desc = "commit",
    },
    {
      [1] = "<LocalLeader>" .. val.map_keyword.git .. "l",
      [2] = "<cmd>NeogitLog<CR>",
    },
  },
  config = function(_, opts)
    require("neogit").setup(opts)
  end,
  specs = {
    [1] = "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function()
      require("state.lualine-ft-data"):add({
        NeogitStatus = { display_name = "NeogitStatus", icon = icons.git },
        -- NeogitWorkTreePopup
        -- NeogitCommitMessage
        -- NeogitPopUp
      })
    end,
  },
}
