--------------------------------------------------------------------------------
-- VIM UI
--------------------------------------------------------------------------------
-- vim.opt.laststatus = 2 -- 상태라인
vim.opt.showmode = true -- no showmode under status line. e.g.) INSERT, REPLACE
vim.opt.cursorline = true -- cursorline = color cursorline
vim.opt.showcmd = true -- showcmd under status line. e.g.) 32j
vim.opt.cmdheight = 1

vim.opt.ruler = true -- display ruler on the right side of the *status line*
vim.opt.number = true -- display number of lines left
-- relativenumber랑 사용하면 현재 줄 만 표기됨
vim.opt.relativenumber = true --  display number of lines w/ relativenumber
vim.opt.hlsearch = true --  highlight all search matches
vim.opt.ignorecase = true -- Search Option: ignore case
vim.opt.smartcase = true -- 대문자가 검색어 문자열에 포함될 때에는 noignorecase

-- vim.opt.incsearch  = true     -- 검색 키워드 입력시 한 글자 입력할 때마다 점진 검색
vim.opt.showmatch = true --  show parenthesis that match

--------------------------------------------------------------------------------
--  VIM Options : Basic Options
--------------------------------------------------------------------------------
-- set autowrite
-- set autoread

vim.opt.errorbells = false
vim.opt.visualbell = true -- use visual bell

vim.opt.history = 1000

vim.opt.foldmethod = "syntax"
vim.opt.foldenable = false -- disable folding at startup
-- vim.opt.foldlevelstart = 10 -- default -1
vim.opt.foldlevel = 999 -- default 0 (fold-all)

-- TODO: fish가 아닐때 vim.env.SHELL 값쓰기.  <2022-04-14, Hyunjae Kim>
vim.opt.shell = "bash"

vim.opt.undofile = false
vim.opt.swapfile = false
vim.opt.backup = false

-------------------------------------------------------------------------------
-- DISABLE AUTO Word Break
-------------------------------------------------------------------------------
-- https://vim.fandom.com/wiki/Word_wrap_without_line_breaks
vim.opt.wrap = true
vim.opt.textwidth = 0
vim.opt.linebreak = false -- true 면 단어 중간에 wrap 금지

-------------------------------------------------------------------------------
-- complete: set the matches for insert mode completion
-- default: .wbut ?
vim.opt.complete = ".,w,b,u,t,i"

----------
-- NOTE: opt.title has error on 0.8.1 <2023-03-02>
-- vim.opt.title = true

--------------------------------------------------------------------------------
--[[
 DISABLE comment while inserting new line (:help fo-table)
 set formatoptions-=r   " Enter
 set formatoptions-=o   " New line created by O
 set formatoptions-=c   " wrap comment using textwidth
--]]

-- formatoptions 는 쉽게 override 된다.
vim.opt.formatoptions:remove("r")
vim.opt.formatoptions:remove("o")
-- autocmd 로 처리
-- defaults: tcqj (2022-05-15)

-----------------------------
-- vim.opt.mouse = ""

----
vim.opt.splitbelow = true
vim.opt.splitright = false -- default
