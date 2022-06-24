" VIM_DIR/vim-include/set-youcompleteme.vim

" Plugin : You Complete Me settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ycm_key_list_select_completion = ['<C-n>']
let g:ycm_key_list_previous_completion=['<C-p>']

if has('mac')
	let g:ycm_server_python_interpreter = '/usr/local/bin/python3'
endif

let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings = 1
let g:ycm_complete_in_comments = 1
let g:ycm_min_num_of_chars_for_completion = 1

" emtpy blacklist
let g:ycm_filetype_blacklist = {}

" let complete=.,w,b,u,t,i
" .: 현재 편집중인 버퍼의 모든 단어를 자동완성 소스로 사용한다.
" w: vim에 현재 열려 있는 window들의 모든 단어를 사용한다.
" b: 버퍼 리스트에 있고 로드된 버퍼들의 모든 단어를 사용한다.
" u: 버퍼 리스트에 있고 로드되지 않은 버퍼들의 모든 단어를 사용한다.
" t: tag completion을 사용한다. ctags를 사용한다면 당연한 설정.
" i: 현재 파일과 include된 파일의 단어를 사용한다.
" 기존에는 i 가 없어서 수동으로 설정함. (2020-10-13)
