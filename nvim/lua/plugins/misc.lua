return {
  -- vimL plugin
  -- repl/repl-like
  { 'michaelb/sniprun', lazy = true, build = 'bash ./install.sh' },
  -- run test
  { 'vim-test/vim-test', lazy = true },

  -- TODO: replace following with https://github.com/kylechui/nvim-surround  <2023-01-10, Hyunjae Kim>
  { 'tpope/vim-surround' },

  { 'ap/vim-css-color' }, -- preview color
  { 'tpope/vim-repeat' },
  { 'tpope/vim-fugitive' },

  -- misc
  {
    'h-hg/fcitx.nvim',
    lazy = true,
    event = { "InsertEnter" },
    cond = vim.fn.executable("fcitx5-remote")
  },
  {
    "akinsho/toggleterm.nvim",
    tag = '2.3.0',
    lazy = true,
    event = { "CmdlineEnter" },
    config = function()
      require("toggleterm").setup()
    end
  },

  ------------------------------------------------------------------------------
  -- disabled
  ------------------------------------------------------------------------------
  {
    'junegunn/fzf.vim',
    lazy = false,
    enabled = false,
    cond = vim.fn.executable("fzf") == 1,
  },
  { 'wfxr/minimap.vim', enabled = false },
  { 'neoclide/jsonc.vim', lazy = true, enabled = false },
  { 'vimwiki/vimwiki', lazy = true, enabled = false },
}
