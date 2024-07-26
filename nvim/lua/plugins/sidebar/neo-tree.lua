local val = require("val")

---@type LazySpec
return {
  [1] = "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
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
      [1] = val.prefix.sidebar .. val.map_keyword.filemanager,
      [2] = "<cmd>Neotree toggle<CR>",
      desc = "neotree-toggle",
    },
    {
      [1] = val.prefix.focus .. val.map_keyword.filemanager,
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
        local icons = require("val").icons
        require("state.lualine-ft-data"):add({
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
