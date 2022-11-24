" Filetype
" :set filetype? or :set ft?
" Filetype : xml {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetype : Snippets {{{
autocmd Filetype snippets setlocal noexpandtab
"
autocmd Filetype conf setlocal foldmethod=marker
autocmd Filetype conf setlocal foldlevel=0
autocmd Filetype conf setlocal colorcolumn=81

autocmd Filetype cfg setlocal colorcolumn=0
autocmd filetype dosini setlocal foldmethod=marker

let g:markdown_fenced_languages = [
      \ 'vim',
      \ 'help'
      \]
autocmd Filetype fstab setlocal expandtab
