local globals = require("globals")

---@type LazySpec
return {
  [1] = "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cond = not vim.g.vscode,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      [1] = "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      optional = true,
    },
    "MunifTanjim/nui.nvim",
  },
  lazy = true,
  -- enabled = false,
  cmd = {
    "Neotree",
  },
  keys = {
    {
      [1] = globals.prefix.sidebar .. globals.map_keyword.filemanager,
      [2] = "<cmd>Neotree toggle<CR>",
      desc = "neotree-toggle",
    },
    {
      [1] = globals.prefix.focus .. globals.map_keyword.filemanager,
      [2] = "<cmd>Neotree<CR>",
      desc = "focus-neotree",
    },
  },
  opts = {
    filesystem = {
      hijack_netrw_behavior = "disabled",
    },
    window = {
      -- mappings = {
      --   D = "delete",
      --   d = "add_directory",
      --   R = "rename",
      -- },
    },
  },
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function()
        local icons = require("globals").icons
        require("plugins.core.lualine.utils.buffer-attributes"):add({
          ["neo-tree"] = { display_name = "NeoTree", icon = icons.file_tree },
          ["neo-tree-popup"] = {
            display_name = "NeoTree Popup",
            icon = icons.zap,
          },
        })
      end,
    },
  },
}
