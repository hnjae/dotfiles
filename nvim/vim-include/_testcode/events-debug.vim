augroup EventLoggin
  autocmd!
  autocmd BufNewFile * call s:Log('BufNewFile')
  autocmd BufReadPre * call s:Log('BufReadPre')
  autocmd BufAdd * call s:Log('BufAdd')
  autocmd BufEnter * call s:Log('BufEnter')
  autocmd BufHidden * call s:Log('BufHidden')
  autocmd BufNew * call s:Log('BufNew')
  autocmd BufRead * call s:Log('BufRead')
  autocmd BufReadPre * call s:Log('BufReadPre')
  autocmd BufReadCmd * call s:Log('BufReadCmd')
  autocmd BufWinEnter * call s:Log('BufWinEnter')
  autocmd FileType * call s:Log('FileType')
  autocmd User * call s:Log('User')
augroup END

function! s:Log(eventName) abort
  silent execute '!echo '.a:eventName.' >> log'
endfunction
