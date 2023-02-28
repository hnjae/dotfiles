return {
    -- add syntax/indent support for kdl
    { "imsnif/kdl.vim",    lazy = false },
    -- syntax won't work if lazy=true
    { "udalov/kotlin-vim", lazy = false, ft = { "kotlin" } },
}
