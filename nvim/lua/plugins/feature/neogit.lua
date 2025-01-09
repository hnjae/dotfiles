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
  },
  opts = {
    notification_icon = utils.enable_icon and icons.git or "G",
    mappings = {
      status = {
        ["x"] = nil, -- "Discard",
        ["K"] = "Discard",
        --
        ["g"] = "RefreshBuffer",
        --
        ["y"] = nil,
        ["Y"] = "ShowRefs",
      },
      popup = {
        ["p"] = nil,
        ["F"] = "PullPopup",
        ["Z"] = nil,
        ["z"] = "StashPopup",
      },
    },
  },
  keys = {
    {
      [1] = val.prefix.git .. val.map_keyword.git,
      [2] = "<cmd>Neogit<CR>",
      desc = "open-neogit",
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
