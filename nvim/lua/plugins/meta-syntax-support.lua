return {
    -- NOTE: syntax won't work if lazy=true

    -- { "sheerun/vim-polyglot", lazy = false },
    -- included in vim-polyglot
    { "udalov/kotlin-vim", lazy = false, ft = { "kotlin" } },
    { "LnL7/vim-nix", lazy = false, ft = { "nix" } },
    { "mustache/vim-mustache-handlebars", lazy = false, },

    -- add syntax/indent support for kdl
    { "imsnif/kdl.vim",    lazy = false },
}
