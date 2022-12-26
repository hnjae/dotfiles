-- vi: nospell
-- Automatically install packer


-- if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
--   local install_path = vim.fn.stdpath("data") .. "\\site\\pack\\packer\\start\\packer.nvim"
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.executable("git") == 1 and vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = vim.fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print("Installing packer close and reopen Neovim...")
  vim.cmd [[packadd packer.nvim]]
  print("Installing packer fin")
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return 1
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

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
  git = {
    clone_timeout = 10,
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
    -- 2022-07-31 Ok
    -- use { 'neoclide/coc.nvim', branch = 'release', commit = 'be513c7f61d61143e696878ab4c33c8337c15692' }

    -- TODO: only when node neovim availalbe <2022-11-03, Hyunjae Kim>
    if vim.fn.executable("yarn") == 1 then
      use { 'neoclide/coc.nvim', branch = 'release'}
    end
    -- 0.082 x
    -- Plug 'junegunn/fzf', {'dir': '~/.fzf','do': './install --all'}
    if vim.fn.executable("fzf") == 1 then
      use 'junegunn/fzf.vim'
    end
    use 'neoclide/jsonc.vim'
    -- use { 'antoinemadec/coc-fzf' }

    if false and vim.fn.has('nvim-0.7') == 1 then
      -- use {
      --   'tamago324/nlsp-settings.nvim',
      --   requires = { 'neovim/nvim-lspconfig', 'rcarriga/nvim-notify' },
      -- }
      use {
        'williamboman/nvim-lsp-installer',
        requires = { 'neovim/nvim-lspconfig' },
      }
      use { 'hrsh7th/nvim-cmp' }
      use { 'hrsh7th/cmp-nvim-lsp' }
      use { 'hrsh7th/cmp-path' }
      use { 'hrsh7th/cmp-buffer' }
      use { 'hrsh7th/cmp-cmdline' }
      use { 'quangnguyen30192/cmp-nvim-ultisnips' }
      use { 'hrsh7th/cmp-nvim-lua' }

      -- use { 'nvim-lua/lsp-status.nvim' } -- lualine 에서 setup 해야함.
      use { 'ray-x/lsp_signature.nvim' } -- it shows popup window.
      use { 'onsails/lspkind.nvim' } -- it shows kind icons
    end

    if vim.fn.has('nvim-0.8.0') == 1 then
      use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
      use { 'p00f/nvim-ts-rainbow', requires = {'nvim-treesitter/nvim-treesitter', run = ":TSUpdate"} }
      use { 'nvim-treesitter/nvim-treesitter-context', requires = {'nvim-treesitter/nvim-treesitter', run = ":TSUpdate"} }
      use { 'toppair/prospector.nvim', opt = false, registers = 'nvim-treesitter/nvim-treesitter'  }
    end

    if vim.g.loaded_python3_provider ~= 0 then
      use { 'puremourning/vimspector' }
      use 'sirver/ultisnips'
    end
    -- use { 'mfussenegger/nvim-dap' }
    -- use { 'mfussenegger/nvim-dap-python' }

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
      'psf/black',
      ft = { 'python' },
    }
    use {
      'brentyi/isort.vim',
      ft = { 'python' },
    }
    use {
      'tenfyzhong/autoflake.vim',
      ft = { 'python' },
    }
    use {
      'rust-lang/rust.vim',
      ft = { 'rust' },
    }
    -- vimscript
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
    -- use 'jiangmiao/auto-pairs'
    -- use 'reedes/vim-lexical'
    use { "windwp/nvim-autopairs" }

    -- CODE DISPLAY
    -- ## color scheme
    use { 'tomasiser/vim-code-dark', opt = false }
    -- use { 'arnau/teaspoon.nvim', opt = false, requires = 'rktjmp/lush.nvim' }

    --
    use { 'projekt0n/github-nvim-theme', opt = false }
    use { 'rafamadriz/neon', opt = false }
    use { 'Mofiqul/vscode.nvim', opt = false }
    use { 'kvrohit/rasmus.nvim', opt = false }
    -- use { 'arnau/teaspoon.nvim', opt = false }
    use { 'Mofiqul/adwaita.nvim', opt = false }
    use { 'marko-cerovac/material.nvim', opt = false }
    use { 'ellisonleao/gruvbox.nvim', opt = false }
    use { 'dracula/vim', opt = false }

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
    -- if vim.fn.
    -- end
    -- m의 mark 가 보이게 해준다.
    use 'kshenoy/vim-signature'

    if vim.fn.executable("fcitx5") == 1 then
      use 'lilydjwg/fcitx.vim'
    end

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

    if vim.fn.executable("cmake") == 1 then
      -- if vim.g.loaded_python3_provider ~= 0 then
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
    end

    -- COMMANDS
    use 'honza/vim-snippets'
    use 'tpope/vim-surround'
    if vim.fn.executable('ctags') == 1 then
      use 'preservim/tagbar'
    end
    -- use 'tpope/vim-commentary'
    use { 'numToStr/Comment.nvim' }
    use { 'ntpeters/vim-better-whitespace' }
    -- use { 'easymotion/vim-easymotion' }
    use { 'phaazon/hop.nvim', branch = 'v2' }
    -- use 'svermeulen/vim-easyclip'

    -- code-runner
    -- use { 'CRAG666/code_runner.nvim' }
    -- use { 'pianocomposer321/yabs.nvim' }

    -- repl/repl-like
    use { 'michaelb/sniprun', run = 'bash ./install.sh'}
    -- run test
    use { 'vim-test/vim-test' }

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
    use { 'scrooloose/nerdtree', requires = { 'tiagofumo/vim-nerdtree-syntax-highlight' } }
    use { 'tpope/vim-vinegar' }
    use { 'tpope/vim-repeat' }
    use { 'tpope/vim-fugitive' }
    -- use { 'tpope/vim-scriptease' }

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

    if vim.fn.has('nvim-0.7') == 1 then
      use {"akinsho/toggleterm.nvim", tag = 'v2.*'}
    end

    if PACKER_BOOTSTRAP then
      packer.sync()
    end
  end,
  config = {
    compile_path = _PACKER_COMPILED
  }
})
