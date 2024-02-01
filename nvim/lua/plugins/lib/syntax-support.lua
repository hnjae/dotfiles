return {
  -- NOTE: syntax won't work if lazy=true

  -- { "sheerun/vim-polyglot", lazy = false },
  -- included in vim-polyglot
  { [1] = "udalov/kotlin-vim", lazy = false, ft = { "kotlin" } },
  { [1] = "LnL7/vim-nix", lazy = false, ft = { "nix" } },
  { [1] = "mustache/vim-mustache-handlebars", lazy = false },

  -- add syntax/indent support for kdl
  { [1] = "imsnif/kdl.vim", lazy = false, enabled = true },
}
