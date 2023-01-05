-- explores code/file etc
return {
  {
    "simrat39/symbols-outline.nvim",
    lazy = false,
    -- event = { "VimEnter" },
    config = {
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
    "nvim-tree/nvim-tree.lua",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    -- enabled = false,
    config = {
      hijack_directories = {
        enable = true,
        auto_open = true,
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
  },

  ---------------------------------------------------
  -- disabled
  ---------------------------------------------------
  {
    'scrooloose/nerdtree',
    lazy = false,
    enabled = false,
    dependenceis = { 'tiagofumo/vim-nerdtree-syntax-highlight' },
    config = function()
      vim.g.NERDTreeHijackNetrw = 0
      vim.g.NERDTreeMinimalUI = 0
      vim.g.NERDTreeDirArrows = 1
      vim.g.NERDTreeQuitOnOpen = 1
      vim.g.NERDTreeShowHidden = 1
      -- autocmd bufenter * if (winnr(“$”) == 1 && exists(“b:NERDTreeType”) && b:NERDTreeType == “primary”) | q | endif
      -- https://medium.com/@victormours/a-better-nerdtree-setup-3d3921abc0b9
    end
  },
  { 'tpope/vim-vinegar', enabled = false },
}
