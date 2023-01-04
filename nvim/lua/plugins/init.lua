local M = {}

M.packages = {
  -- vimL plugin
  { "dstein64/vim-startuptime" },
  {'neoclide/jsonc.vim', lazy = true },
  { 'junegunn/fzf.vim', lazy = true, cond = vim.fn.executable("fzf") == 1 },
  -- repl/repl-like
  { 'michaelb/sniprun', lazy = true, build = 'bash ./install.sh' },
  -- run test
  { 'vim-test/vim-test', lazy = true },
  { 'vimwiki/vimwiki', lazy = true },
  -- m의 mark 가 보이게 해준다.
  { 'kshenoy/vim-signature' },
  { 'mhinz/vim-startify' },
  { 'honza/vim-snippets' },
  { 'tpope/vim-surround'},
  { 'wfxr/minimap.vim', enabled = false },
  { 'johngrib/vim-f-hangul' },
  { 'ap/vim-css-color' },
  { 'tpope/vim-vinegar' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-fugitive' },
  { 'habamax/vim-asciidoctor' },
  -- language
  {'lervag/vimtex', lazy = true, ft= {"tex"}},
  { 'python-mode/python-mode', lazy=true, branch = 'develop', ft = { 'python' }, },
  { 'rust-lang/rust.vim', lazy=true, ft = { 'rust' }, },
  {'ludovicchabant/vim-gutentags' },

  -- dev
  -- { "folke/neodev.nvim" },
  { 'puremourning/vimspector', lazy=true, cond=vim.fn.has('python3') },
    -- use { 'mfussenegger/nvim-dap' }
    -- use { 'mfussenegger/nvim-dap-python' }

  -- treesitter
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  {
    'p00f/nvim-ts-rainbow',
    dependenceis = { 'nvim-treesitter/nvim-treesitter' }
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependenceis = { 'nvim-treesitter/nvim-treesitter' }
  },

  -- editing experince
  { 'numToStr/Comment.nvim' },
  { 'ntpeters/vim-better-whitespace' },
  { "windwp/nvim-autopairs" },
  { 'sirver/ultisnips', lazy=false, cond=vim.fn.has('python3') },

  -- cmp
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp', dependenceis = { 'hrsh7th/nvim-cmp' }},
  { 'hrsh7th/cmp-path', dependenceis = { 'hrsh7th/nvim-cmp' } },
  { 'hrsh7th/cmp-buffer', dependenceis = { 'hrsh7th/nvim-cmp' } },
  { 'hrsh7th/cmp-cmdline', dependenceis = { 'hrsh7th/nvim-cmp' } },
  { 'hrsh7th/cmp-nvim-lua', dependenceis = { 'hrsh7th/nvim-cmp' } },
  {
    'quangnguyen30192/cmp-nvim-ultisnips',
    dependenceis = { 'hrsh7th/nvim-cmp', 'sirver/ultisnips' }
  },

  -- lsp
  { 'neovim/nvim-lspconfig' },
  { "simrat39/symbols-outline.nvim" },
  { 'rcarriga/nvim-notify' },
  {
    'tamago324/nlsp-settings.nvim',
    dependenceis = {
      'neovim/nvim-lspconfig',
      'rcarriga/nvim-notify',
      'williamboman/nvim-lsp-installer'
    },
  },
  {
    'williamboman/nvim-lsp-installer',
    dependenceis = { 'neovim/nvim-lspconfig' },
  },
  -- use { 'nvim-lua/lsp-status.nvim' } -- lualine 에서 setup 해야함.
  -- it shows popup window.
  {
    'ray-x/lsp_signature.nvim',
    config = function() require('lsp_signature').setup() end
  },
  { 'onsails/lspkind.nvim' }, -- it shows kind icons
  -- {
  --   'neoclide/coc.nvim',
  --   branch = 'release',
  --   enabled = false and vim.fn.has("node") == 1
  -- },
  -- {
  --   'antoinemadec/coc-fzf',
  --   branch = 'release',
  --   dependenceis = { 'neoclide/coc.nvim' },
  --   enabled =false
  -- },

  -- UI
  { "folke/which-key.nvim" }, -- set keymap / show keymap
  {'lukas-reineke/indent-blankline.nvim'}, -- show indent line
  {
    'nvim-lualine/lualine.nvim',
    dependenceis = { 'kyazdani42/nvim-web-devicons'},
    lazy = true
  },
  { 'kdheepak/tabline.nvim' },
  {
    'akinsho/bufferline.nvim',
    tag = "v3.1.0",
    dependenceis = { 'kyazdani42/nvim-web-devicons' }
  },

  -- colorscheme
  { 'Mofiqul/vscode.nvim', lazy = false },
  {
    'toppair/prospector.nvim', lazy = true ,
    dependenceis = { 'nvim-treesitter/nvim-treesitter' }
  },
  { 'projekt0n/github-nvim-theme', lazy = true },
  { 'rafamadriz/neon', lazy = true },
  { 'kvrohit/rasmus.nvim', lazy = true },
  { 'Mofiqul/adwaita.nvim', lazy = true },
  { 'marko-cerovac/material.nvim', lazy = true },
  { 'ellisonleao/gruvbox.nvim', lazy = true },



  -- { 'dracula/vim', lazy = true },


      -- if vim.g.loaded_python3_provider ~= 0 then

  -- telescope
  { 'nvim-lua/plenary.nvim' },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release"
      .. " && cmake --build build --config Release"
      .. " && cmake --install build --prefix build",
    cond = vim.fn.executable("cmake") == 1
  },
  { 'fhill2/telescope-ultisnips.nvim', dependenceis = { 'sirver/ultisnips' } },
  {
    'nvim-telescope/telescope.nvim',
    dependenceis = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
      'fhill2/telescope-ultisnips.nvim'
    },
  },

  -- misc
  { 'h-hg/fcitx.nvim', cond = vim.fn.executable("fcitx5-remote") },
  { 'phaazon/hop.nvim', branch = 'v2' },
  { "akinsho/toggleterm.nvim", tag = '2.3.0', lazy=true },
  { 'tiagofumo/vim-nerdtree-syntax-highlight', lazy=true },
  {
    'scrooloose/nerdtree',
    lazy=true,
    dependenceis = { 'tiagofumo/vim-nerdtree-syntax-highlight' },
  },
}


M.setup = function()
  if vim.fn.has('nvim-0.8') ~= 1 then
    return
  end

  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup({
    spec = M.packages,
    lockfile= vim.fn.stdpath("data") .. "/lazy-lock.json"
  })
end

return M
