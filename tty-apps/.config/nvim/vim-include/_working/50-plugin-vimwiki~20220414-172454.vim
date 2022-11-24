augroup vimwikiauto
    " autocmd BufWritePre *wiki/*.wiki call LastModified()
    autocmd BufWritePre *wiki/*.md call LastModified()
    autocmd BufRead,BufNewFile *wiki/*.md call NewTemplatePure()

    " <C-s> 로 테이블에서 오른쪽 컬럼으로 이동한다.
    autocmd FileType vimwiki inoremap <C-s> <C-r>=vimwiki#tbl#kbd_tab()<CR>
    " <C-a> 로 테이블에서 왼쪽 컬럼으로 이동한다.
    autocmd FileType vimwiki inoremap <C-a> <Left><C-r>=vimwiki#tbl#kbd_shift_tab()<CR>
augroup END

" hi VimwikiHeader1 guifg=htmlH1
" hi VimwikiHeader3 guifg=#0000FF
" hi VimwikiHeader4 guifg=#FF00FF
" hi VimwikiHeader5 guifg=#00FFFF
" hi VimwikiHeader6 guifg=#FFFF00
