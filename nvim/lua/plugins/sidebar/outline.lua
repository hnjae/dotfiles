local prefix = require("val").prefix
local map_keyword = require("val").map_keyword

---@type LazySpec
return {
  [1] = "hedyhli/outline.nvim",
  lazy = true,
  cmd = {
    "Outline",
    "OutlineOpen",
    "OutlineClose",
    "OutlineFocus",
    "OutlineFocusCode",
    "OutlineFocusOutline",
    "OutlineFollow",
    "OutlineStatus",
    "OutlineRefresh",
  },
  ---@type LazyKeysSpec[]
  keys = {
    {
      [1] = prefix.sidebar .. map_keyword.symbols,
      [2] = "<cmd>Outline<CR>",
      desc = "outline (symbols)",
    },
    {
      [1] = prefix.focus .. map_keyword.symbols,
      [2] = "<cmd>OutlineFocus<CR>",
      desc = "outline (symbols)",
    },
  },
  dependencies = {
    "onsails/lspkind.nvim",
    "neovim/nvim-lspconfig",
  },
  opts = {
    symbols = {
      icon_source = "lspkind",
    },
    outline_window = {
      width = 20,
    },
  },
}
