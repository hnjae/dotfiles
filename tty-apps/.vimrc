filetype on
filetype plugin on
filetype plugin indent on

iabbr <expr> __time strftime("%Y-%m-%d %H:%M:%S")
iabbr <expr> __date strftime("%Y-%m-%d")
iabbr <expr> __file expand('%:p')
iabbr <expr> __name expand('%')
iabbr <expr> __pwd expand('%:p:h')
iabbr <expr> __branch system("git rev-parse --abbrev-ref HEAD")
iabbr <expr> __uuid system("uuidgen")

let mapleader = " "
let maplocalleader = ","

nmap <Leader><Leader> za
nmap ZA "<cmd>wa<CR>"

" VIM Mode 에 따라 커서 Shape 바뀌는 옵션 해제
set guicursor=""

set fileencodings=utf-8,cp949,iso-2022-jp,euc-jp,shift-jis,cp949,latin1
set fileformats=unix,dos,mac
set encoding=utf-8

set smarttab
set smartindent
" automatically inserts one extra level of indentation in some case.
" full width char mapping
set matchpairs+=（:）
set matchpairs+=「:」
set matchpairs+=｛:｝
set matchpairs+=＜:＞
set matchpairs+=【:】
set matchpairs+=『:』
set matchpairs+=［:］
set matchpairs+=《:》
set matchpairs+=〔:〕

" half width char mapping
set matchpairs+=‘:’
set matchpairs+=“:”
set matchpairs+=«:»
set matchpairs+=‹:›
set matchpairs+=｢:｣
set matchpairs+=[:]
set matchpairs+=<:>
set matchpairs+=`:`

set nospell
set laststatus=1
set showmode
set cursorline
set showcmd
set cmdheight=2

set ruler
set number
set relativenumber
set hlsearch
set smartcase

set showmatch

set noerrorbells
set visualbell

set history=1000
set foldmethod=syntax
set foldlevelstart=6
" set shell=zsh

set undofile
set swapfile
set backup

set wrap
set textwidth=0

set complete=".,w,b,u,t,i"
set title

let netrw_bufsettings = 'noma nomod nonu nobl nowrap ro nornu number relativenumber'
let loaded_ruby_provider = 0
let loaded_python_provider = 0
let loaded_perl_provider = 0

syntax enable
