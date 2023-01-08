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
    dependencies = { 'tiagofumo/vim-nerdtree-syntax-highlight' },
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
  {
    'ludovicchabant/vim-gutentags',
    lazy = true,
    ft = { "asciidoc", "asciidoctor" },
    config = function()
      vim.g.gutentags_cache_dir = vim.fn.stdpath('cache') .. "/gutentags"
      vim.g.gutentags_exclude_filetypes = {
        '',
        'fugitive',
        'nerdtree',
        'tagbar',
        'help',
      }
    end
  },
  {
    'preservim/tagbar',
    lazy = true,
    ft = { "asciidoc", "asciidoctor" },
    config = function()
      vim.g.tagbar_width = 26 -- default: 40
      vim.g.tagbar_wrap = 0
      vim.g.tagbar_zoomwidth = 0 -- default 1 (use maximum width)
      vim.g.tagbar_indent = 1
      vim.g.tagbar_show_data_type = 1
      vim.g.tagbar_help_visiblity = 1
      vim.g.tagbar_show_balloon = 1

      vim.g.tagbar_type_asciidoctor = {
        ['sro'] = '""',
        ['sort'] = 0,
        ['ctagstype'] = 'asciidoc',
        ['kinds'] = {
          'c:chapter:0:1',
          's:section:0:1',
          'S:subsection:0:1',
          't:subsubsection:0:1',
          'T:l4subsection:0:1',
          'u:l5subsection:0:1',
          'a:anchor:0:1',
        },
        ['kind2scope'] = {
          ['c'] = 'chapter',
          ['s'] = 'section',
          ['S'] = 'subsection',
          ['t'] = 'subsubsection',
          ['T'] = 'l4subsection',
          ['u'] = 'l5subsection',
          ['a'] = 'anchor',
        },
        ['scope2kind'] = {
          ['chapter']       = 'c',
          ['section']       = 's',
          ['subsection']    = 'S',
          ['subsubsection'] = 't',
          ['l4subsection']  = 'T',
          ['l5subsection']  = 'u',
          ['anchor']        = 'a',
        },
      }

      vim.keymap.set("n", "[t", "<cmd>TagbarJumpPrev<CR>", { desc = "prev-tag" })
      vim.keymap.set("n", "]t", "<cmd>TagbarJumpNext<CR>", { desc = "next-tag" })

      vim.keymap.set("n", _MAPPING_PREFIX["sidebar"] .. "t", "<cmd>TagbarToggle<CR>", { desc = "tagbar" })

    end
  }
}
