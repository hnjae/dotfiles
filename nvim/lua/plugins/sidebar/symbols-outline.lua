local prefix = require("val").prefix

---@type LazyPlugin
return {
  [1] = "simrat39/symbols-outline.nvim",
  lazy = true,
  cmd = {
    "SymbolsOutline",
    "SymbolsOutlineOpen",
    "SymbolsOutlineClose",
  },
  ---@type LazyKeysSpec[]
  keys = {
    {
      [1] = prefix.sidebar .. "s",
      [2] = "<cmd>SymbolsOutline<CR>",
      desc = "symbols-outline",
    },
  },
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  opts = {
    width = 17,
    keymaps = {
      unfold = "o",
      unfold_all = "O",
      fold = "c",
      fold_all = "C",
      fold_reset = "X",
    },
    -- symbol_blacklist = {
    --   "String", "Number", "Constant", "Variable"
    -- },
  },
}
