" VIM_DIR/vim-include/

" 2021-11-30 현재 Ultisnips 기능은 coc-snippet 에서 대신하고 있다.
" 그렇지 않음. preview 만 하고 있을 뿐..
"
" Plugin : ultisnips settings
inoremap <c-x><c-k> <c-x><c-k>
let g:UltiSnipsExpandTrigger = '<tab>'
" let g:UltiSnipsListSnippets = '<c-tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'    " default: <c-j>
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>' " default: <c-k>
let g:UltiSnipsEditSplit="horizontal" " if you want
let g:UltiSnipsSnippetDirectories = ['~/.config/nvim/UltiSnips', 'UltiSnips']

" 다음 링크에서 따옴. 한번 읽어보자 https://github.com/SirVer/ultisnips/issues/711
