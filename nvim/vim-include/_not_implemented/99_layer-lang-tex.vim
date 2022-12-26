" Plugin : VIMTEX Settings

let g:tex_flavor="latex"

" After installing Plug-tex-conceal
autocmd Filetype tex set conceallevel=2

if has("mac")
	let g:vimtex_view_method='skim'
elseif has("unix")
	let g:vimtex_view_method='zathura'
endif

" neovim-remote needed
let g:vimtex_compiler_progname = 'nvr'
" to use synctex in neovim / neovim-remote(pip3) should be installed
" Synctex synchronize the position of the editor and viewer
" let g:vimtex_quickfix_mode=0

" COMPLETE FILEs
let g:vimtex_complete_enabled=1
let g:vimtex_complete_close_braces=1 " default 0 (2021-01-16)

" SYNTAX HIGHLIGHTING
let g:vimtex_syntax_enabled=1
" let g:vimtex_syntax_nested =1

" Folding
let g:vimtex_fold_enabled = 1
autocmd Filetype tex set foldlevel=6 " using vimtex's foldmethod

" INDENTATION
autocmd Filetype tex set nosmartindent
autocmd Filetype tex set nocindent
autocmd Filetype tex set noautoindent
let g:vimtex_indent_enabled=1
let g:vimtex_indent_bib_enabled=1

" let g:vimtex_indent_delims " not working don't know why
" let g:vimtex_indent_ignored_envs
" let g:vimtex_indent_lists "not working_don't know why
" let g:vimtex_indent_on_ampersands=1

" Auto Complete using YouCompleteMe
" if !exists('g:ycm_semantic_triggers')
" 	autocmd Filetype tex let g:ycm_semantic_triggers = {}
" 	autocmd Filetype tex au VimEnter * let g:ycm_semantic_triggers.tex=g:vimtex#re#youcompleteme
" endif

" Tabs
" syntatic's chktex will not work if tabstop is not 8
autocmd Filetype tex set tabstop=8
autocmd Filetype tex set shiftwidth=2
autocmd Filetype tex set softtabstop=2
autocmd Filetype tex set expandtab

" Shortcuts!
nmap <LocalLeader>lt <Plug>(vimtex-toc-toggle)
nmap <LocalLeader>lw :VimtexCountWords<Cr>
nmap <LocalLeader>lW :VimtexCountLetters<Cr>
"  p <F6> :VimtexCountWords<Cr>

" UI
autocmd Filetype tex set colorcolumn=0
