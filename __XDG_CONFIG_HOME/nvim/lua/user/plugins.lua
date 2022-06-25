-- vi: nospell
-- Automatically install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
--   local install_path = vim.fn.stdpath("data") .. "\\site\\pack\\packer\\start\\packer.nvim"
-- else
--   local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
-- end

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = vim.fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- PackerSync: Clean, Updates, Install, Compiles
-- local augroup_packer_user_config = vim.api.nvim_create_augroup("packer_user_config", {})
-- vim.api.nvim_create_autocmd(
--   {"BufWritePost"}, {
--     group = augroup_packer_user_config,
--     pattern = {"*/lua/user/plugins.lua"},
--     callback = function()
--     end
--   }
-- )
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost */lua/user/plugins.lua source <afile> | PackerSync
    autocmd BufWritePost */lua/user/plugins.lua helptags ALL
  augroup end
]]


-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
  max_jobs = 6
}

-- TODO: use spell check
local util = require('packer/util')
_PACKER_COMPILED = util.join_paths(vim.fn.stdpath('data'), 'packer', 'packer_compiled.lua')
if vim.fn.empty(vim.fn.glob(_PACKER_COMPILED)) > 0 then
  vim.cmd([[PackerCompile]])
end

return packer.startup({
  function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- IDE
    -- use { 'neoclide/coc.nvim', branch = 'release' }
    use {
      'williamboman/nvim-lsp-installer',
      requires = { 'neovim/nvim-lspconfig' },
    }
    use { 'nvim-lua/lsp-status.nvim' }
    use { 'ray-x/lsp_signature.nvim' }
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use { 'mfussenegger/nvim-dap' }

    use { 'p00f/nvim-ts-rainbow', requires = {'nvim-treesitter/nvim-treesitter'} }
    use { 'nvim-treesitter/nvim-treesitter-context', requires = {'nvim-treesitter/nvim-treesitter'} }
    -- LANGUAGE
    use {
      'lervag/vimtex',
      ft = { 'tex' },
    }
    use {
      'python-mode/python-mode',
      branch = 'develop',
      ft = { 'python' },
    }
    use {
      'rust-lang/rust.vim',
      ft = { 'rust' },
    }
    use { 'junegunn/vader.vim' }
    use {
      'mfussenegger/nvim-jdtls',
      -- ft = { 'java' },
    }
    -- use {
    --   'iamcco/markdown-preview.nvim',
    --   ft = { "markdown", "vimwiki" },
    --   run = 'cd app && yarn install',
    --   requires = {
    --     'godlygeek/tabular',
    --     {'preservim/vim-markdown'} -- 여기서 ft 하면 markdown-preview 가 먹질 않음
    --   }
    -- }
    -- use {
    --   'preservim/vim-markdown',
    --   requires = {
    --     'godlygeek/tabular',
    --     {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install'}
    --   },
    --   ft = { 'markdown' },
    -- }



    -- COMPLETION
    ---------------------------------------------
    use 'ludovicchabant/vim-gutentags'
    use 'jiangmiao/auto-pairs'
    -- use 'reedes/vim-lexical'
    if vim.fn.has('nvim-0.7') == 1 then
      use { 'hrsh7th/nvim-cmp' }
      use { 'hrsh7th/cmp-nvim-lsp' }
      use { 'hrsh7th/cmp-path' }
      use { 'hrsh7th/cmp-buffer' }
      use { 'hrsh7th/cmp-cmdline' }
      use { 'quangnguyen30192/cmp-nvim-ultisnips' }
      use { 'hrsh7th/cmp-nvim-lua' }
    end

    -- CODE DISPLAY
    -- ## color scheme
    -- use { 'tomasiser/vim-code-dark', opt = false }
    -- use { 'arnau/teaspoon.nvim', opt = false, requires = 'rktjmp/lush.nvim' }
    use { 'toppair/prospector.nvim', opt = false, registers = 'nvim-treesitter/nvim-treesitter'  }

    --
    use { 'projekt0n/github-nvim-theme', opt = false }
    use { 'Mofiqul/vscode.nvim', opt = false }
    use { 'kvrohit/rasmus.nvim', opt = false }
    -- use { 'arnau/teaspoon.nvim', opt = false }
    use { 'Mofiqul/adwaita.nvim', opt = false }
    use { 'marko-cerovac/material.nvim', opt = false }
    use { 'ellisonleao/gruvbox.nvim', opt = false }

    -- use { 'morhetz/gruvbox', opt = true, }
    -- use { 'nanotech/jellybeans.vim', opt = true, }
    -- use { 'tomasr/molokai', opt = true, }
    -- use { 'jacoborus/tender.vim', opt = true, }
    -- use { 'w0ng/vim-hybrid', opt = true, }
    -- use { 'chriskempson/base16-vim', opt = true, }
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use { 'kdheepak/tabline.nvim' }
    use {
      'akinsho/bufferline.nvim',
      tag = "*", requires = 'kyazdani42/nvim-web-devicons'
    }

    -- INTEGRATION
    use 'sirver/ultisnips'
    -- m의 mark 가 보이게 해준다.
    use 'kshenoy/vim-signature'
    use 'lilydjwg/fcitx.vim'
    use { 'folke/which-key.nvim' }
    -- netrw 개선
    -- use 'yggdroot/indentline'
    -- use 'ctrlpvim/ctrlp.vim'
    -- use 'delle/vim-languagetool'

    -- INTERFACE
    use 'mhinz/vim-startify'
    -- nerd 폰트 필요
    -- use 'ryanoasis/vim-devicons'
    -- use 'vim-airline/vim-airline'
    -- use 'vim-airline/vim-airline-themes'
    use {
      'wfxr/minimap.vim',
      disable = true
    }
    use 'junegunn/fzf.vim'
    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
        },
        'fhill2/telescope-ultisnips.nvim'
      }
    }

    -- COMMANDS
    use 'honza/vim-snippets'
    use 'tpope/vim-surround'
    use 'preservim/tagbar'
    use 'tpope/vim-commentary'
    use { 'tpope/vim-repeat' }
    use { 'ntpeters/vim-better-whitespace' }

    -- OTHERS
    use 'vimwiki/vimwiki'
    -- use { 'renerocksai/telekasten' }
    -- use { 'lervag/wiki.vim' }
    -- use { 'preservim/vim-markdown' }
    -- use {
    --   'nvim-orgmode/orgmode',
    --   requires = {
    --     'nvim-treesitter/nvim-treesitter',
    --   },
    -- }
    -- Plug 'michal-h21/vim-zettel'
    -- Plug '907th/vim-auto-save'
    -- Plug 'freitass/todo.txt-vim'

    -- MISC
    use 'johngrib/vim-f-hangul'
    use 'ap/vim-css-color'
    use 'neoclide/jsonc.vim'
    -- use { 'neoclide/coc.nvim', branch = 'release' }
    use { 'scrooloose/nerdtree', requires = { 'tiagofumo/vim-nerdtree-syntax-highlight' } }
    use { 'tpope/vim-vinegar' }

    -- netrw를 못쓰게 됨
    -- use {
    --   'kyazdani42/nvim-tree.lua',
    --   requires = {
    --     'kyazdani42/nvim-web-devicons', -- optional, for file icon
    --   },
    -- }
    -- netrw를 못쓰게 됨
    -- use { 'ms-jpq/chadtree', branch = 'chad', run =  'python3 -m chadtree deps'}

    -- Asciidoc
    use { 'habamax/vim-asciidoctor' }
    -- use { 'ratfactor/vviki' }
    -- use { 'shuntaka9576/preview-asciidoc.nvim' }

    if PACKER_BOOTSTRAP then
      packer.sync()
    end
  end,
  config = {
    compile_path = _PACKER_COMPILED
  }
})
