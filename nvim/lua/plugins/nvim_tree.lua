return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  lazy = true,
  cmd = {
    "NvimTreeToggle",
    "NvimTreeOpen",
    "NvimTreeClose",
    "NvimTreeFocus",
    "NvimTreeResize",
    "NvimTreeRefresh",
    "NvimTreeCollapse",
    "NvimTreeClipboard",
    "NvimTreeFindFile",
    "NvimTreeFindFileToggle",
    "NvimTreeCollapseKeepBuffers",
  },
  keys = {
    {
      require("var").prefix.sidebar .. "e",
      "<cmd>NvimTreeToggle<CR>",
      desc = "NvimTreeToggle",
    },
  },
  opts = {
    disable_netrw = false,
    hijack_netrw = false,
    hijack_directories = {
      enable = false,
      auto_open = false,
    },
    view = {
      mappings = {},
    },
    diagnostics = {
      enable = false,
      show_on_dirs = false,
      icons = {
        hint = "",
        info = "",
        warning = "",
        error = "",
      },
    },
  },
}
