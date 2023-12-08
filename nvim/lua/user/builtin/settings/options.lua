--------------------------------------------------------------------------------
-- VIM UI
--------------------------------------------------------------------------------
-- set laststatus=2 -- 상태라인
-- vim-airline 에서 대신함.
vim.opt.showmode = false -- no showmode under status line. e.g.) INSERT, REPLACE
vim.opt.cursorline = true -- cursorline = color cursorline
vim.opt.showcmd = true -- showcmd under status line. e.g.) 32j
vim.opt.cmdheight = 2

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

vim.opt.foldmethod = "expr"
vim.opt.foldexpr="nvim_treesitter#foldexpr()"
vim.opt.foldenable = false -- disable folding at startup
-- vim.opt.foldlevelstart = 10 -- default -1

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
-- autocmd FileType * setlocal formatoptions-=r formatoptions-=o
 그냥 set 으로 설정하면 안먹힘. (2022-04-14)
    - 아마도 override 하는 플러그인이 있을터
--]]

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufNew" }, {
  pattern = { "*" },
  callback = function()
    vim.opt_local.formatoptions:remove("r")
    vim.opt_local.formatoptions:remove("o")
  end,
})
-- formatoptions 는 쉽게 override 된다.
-- vim.opt.formatoptions:remove("r")
-- vim.opt.formatoptions:remove("o")
-- defaults: tcqj (2022-05-15)
-- jcroql -- overrided by something?
-- vim.opt.formatoptions = "tcqjpn"
-- t: auto-wrap text using textwidth
-- c: auto-wrap comments using textwidth, inserting the current comment leader automatically
-- q: allow formatting of comments with gq
-- j: remove a comment leader when joining lines.
--
-- p: Don't break lines at single spaces that follow periods.
-- r: auto-insert the current comment leader after hitting <Enter>
-- n: when formatting text, recognize numbered lists. it wraps after "1."
--
-- o: automatically insert the current comment leader after hitting 'o'
