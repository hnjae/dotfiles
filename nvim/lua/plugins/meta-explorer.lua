local prefix = require("val").prefix

-- explores code/file etc
return {
  {
    "simrat39/symbols-outline.nvim",
    lazy = true,
    cmd = {
      "SymbolsOutline",
      "SymbolsOutlineOpen",
      "SymbolsOutlineClose",
    },
    keys = {
      {
        prefix.sidebar .. "s",
        "<cmd>SymbolsOutline<CR>",
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
  },
  {
    "tpope/vim-vinegar",
    lazy = false,
    enabled = true,
    keys = {
      -- { "-", nil, desc = "vinegar-up" },
    }
  },
}
