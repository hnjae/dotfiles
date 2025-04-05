local utils = require("utils")
local icons = require("globals").icons

return {
  [1] = "sindrets/diffview.nvim",
  enabled = true,
  cond = not vim.g.vscode,
  lazy = true,
  cmd = "DiffviewFileHistory",
  opts = {
    use_icons = utils.enable_icon,
    icons = { -- Only applies when use_icons is true.
      folder_closed = "", --nf-cod-folder
      folder_open = "", --nf-cod-folder_opened
    },
    signs = {
      -- fold_closed = "",
      -- fold_open = "",
      -- fold_closed = "󰞘", -- nf-md-expand-right
      -- fold_open = "󰞖", -- nf-md-arrow-expand-down
      -- fold_closed = " ", -- nf-oct-fold
      -- fold_open = " ", -- nf-oct-fold_down
      done = icons.check,
    },
  },
  specs = {
    [1] = "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function()
      require("state.lualine-ft-data"):add({
        DiffviewFileHistory = {
          icon = "", -- nf-cod-diff
        },
      })
    end,
  },
}
