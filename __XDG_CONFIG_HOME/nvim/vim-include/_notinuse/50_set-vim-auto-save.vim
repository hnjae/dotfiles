
" let g:auto_save_silent = 1  " do not display the auto-save notification
" let g:auto_save_events = ["InsertLeave", "TextChanged"]
let g:auto_save_events = ["TextChanged"]

let g:auto_save = 0
let g:auto_save_silent = 1
augroup auto_save_ft
  au!
  au FileType markdown let b:auto_save = 1
  au FileType vimwiki let b:auto_save = 1
  " au FileType vimwiki let b:auto_save_events = ["TextChanged"]
  au FileType text let b:auto_save = 1
augroup END
