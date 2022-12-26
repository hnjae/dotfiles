" https://develop.spacemacs.org/layers/+lang/rust/README.html

autocmd FileType rust TagbarOpen
autocmd FileType rust let &colorcolumn=join(range(99,999),",")

if exists('g:packer_plugins')
            \ && has_key(g:packer_plugins, 'rust.vim')
            \ && packer_plugins['rust.vim'].loaded

    let g:rust_conceal = 0
    let g:rust_conceal_mod_path = 0
    let g:rust_conceal_pub = 0

    " Fold level are controlled  by globalvalue
    let g:rust_fold = 2

    " let g:rustfmt_autosave
    " need webapi-vim
    " let g:rust_clip_command =
    "
    autocmd FileType rust let g:which_key_map['m']['c'] = {
                \ 'name' : 'cargo' ,
                \ '/' : [':Csearch'    , 'cargo search'],
                \ '=' : [''    , 'rustfmt (all project file)'],
                \ 'a' : [''     , 'NA'],
                \ 'A' : [''     , 'NA'],
                \ 'c' : [':Cbuild'     , 'cargo build'],
                \ 'C' : [':Cclean'     , 'cargo clean'],
                \ 'd' : [':Cdoc'       , 'cargo doc'],
                \ 'D' : [':Cdoc'       , 'cargo doc'],
                \ 'e' : [':Cbench'     , 'cargo bench'],
                \ 'E' : [':Cruntarget' , 'cargo run --bin/--example'],
                \ 'i' : [':Cinit'       , 'cargo init'],
                \ 'l' : ['' , 'linter (NA)'],
                \ 'n' : ['' , 'new project (NA)'],
                \ 'o' : ['' , 'outdated depen (NA)'],
                \ 'r' : ['' , 'remove-depen (NA)'],
                \ 'u' : [':Cupdate'    , 'cargo update'],
                \ 'U' : ['' , 'update-depen latest (NA)'],
                \ 'v' : ['' , 'verify project (NA)'],
                \ 'x' : [':Crun'       , 'cargo run'],
                \ }
    " \ 'c' : [':Cpublish'   , 'cargo publish'],
    " \ 'c' : [':Cinstall'   , 'cargo install'],
    autocmd FileType rust let g:which_key_map['m']['t'] = {
                \ 'name' : 'test' ,
                \ 'a' : [':Ctest'      , 'cargo test'],
                \ 't' : [':Ctest'      , 'cargo test'],
                \ 'b' : [':Ctest'      , 'cargo test'],
                \ }
endif
