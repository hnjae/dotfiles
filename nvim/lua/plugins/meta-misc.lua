return {
  { "rust-lang/rust.vim", lazy = true, ft = { "rust" } },
  { "udalov/kotlin-vim", lazy = false, ft = { "kotlin" } }, -- syntax won't work if lazy=true
  -- add syntax/indent support for kdl
  { 'imsnif/kdl.vim', lazy = false },
  -- run test
  { "vim-test/vim-test", lazy = true },
  {
    "tpope/vim-repeat",
    lazy = false,
  },
  {
    "tpope/vim-fugitive",
    lazy = false,
  },
}
