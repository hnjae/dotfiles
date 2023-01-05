-- explores code/file etc
local nvim_tree_spec = {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    { 'nvim-tree/nvim-web-devicons', module = true },
  },
  lazy = false,
  -- event = { "UIEnter" },
  -- enabled = false,
  keys = {
    {
      _MAPPING_PREFIX["sidebar"] .. "t",
      "<cmd>NvimTreeToggle<CR>",
      desc = "NvimTreeToggle"
    },
  },
  config = function()
    require("nvim-tree").setup({
      disable_netrw = false,
      hijack_netrw = false,
      hijack_directories = {
        enable = false,
        auto_open = false,
      },
      view = {
        mappings = {
          -- list = {
          --   { key = "<C-e>", action = "edit" },
          --   { key = "<CR>", action = "edit_in_place" }
          -- }
        }
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
    })
  end
}

return {
  nvim_tree_spec,
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
  { 'tpope/vim-vinegar', enabled = true },

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
}
