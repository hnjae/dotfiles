local val = require("val")

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  -- enabled = false,
  cmd = {
    "Neotree",
  },
  keys = {
    -- {
    --   val.prefix.sidebar .. val.map_keyword.explorer
    --   "<cmd>NvimTreeToggle<CR>",
    --   desc = "NvimTree-toggle",
    -- },
    {
      val.prefix.focus .. val.map_keyword.filemanager,
      "<cmd>Neotree<CR>",
      desc = "focus-neotree",
    },
  },
  opts = {
    filesystem = {
      -- hijack_netrw_behavior = "disabled",
    },
    window = {
      -- mappings = {
      --   D = "delete",
      --   d = "add_directory",
      --   R = "rename",
      -- },
    },
  },
}
