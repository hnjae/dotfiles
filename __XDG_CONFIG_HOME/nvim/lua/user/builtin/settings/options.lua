--------------------------------------------------------------------------------
-- VIM UI
--------------------------------------------------------------------------------
-- set laststatus=2 -- 상태라인
                    -- vim-airline 에서 대신함.
vim.opt.showmode = false  -- no showmode under status line. e.g.) INSERT, REPLACE
                          -- vim-airline 에서 대신함.
vim.opt.cursorline = true -- cursorline = color cursorline
vim.opt.showcmd    = true -- showcmd under status line. e.g.) 32j
vim.opt.cmdheight  = 2

vim.opt.ruler = true          -- display ruler on the right side of the *status line*
vim.opt.number = true         -- display number of lines left
                              -- relativenumber랑 사용하면 현재 줄 만 표기됨
vim.opt.relativenumber = true --  display number of lines w/ relativenumber
vim.opt.hlsearch = true       --  highlight all search matches
vim.opt.ignorecase = true     -- Search Option: ignore case
vim.opt.smartcase  = true     -- 대문자가 검색어 문자열에 포함될 때에는 noignorecase

-- vim.opt.incsearch  = true     -- 검색 키워드 입력시 한 글자 입력할 때마다 점진 검색
vim.opt.showmatch = true      --  show parenthesis that match

--------------------------------------------------------------------------------
--  VIM Options : Basic Options
--------------------------------------------------------------------------------
-- set autowrite
-- set autoread

vim.opt.errorbells = false
vim.opt.visualbell = true -- use visual bell

vim.opt.history = 1000

vim.opt.foldmethod = "syntax"
vim.opt.foldlevelstart = 6

-- TODO: fish가 아닐때 vim.env.SHELL 값쓰기.  <2022-04-14, Hyunjae Kim>
vim.opt.shell = "zsh"

--------------------------------------------------------------------------------
--  VIM Options : Files
--------------------------------------------------------------------------------
local is_note = function(ft)
  if ft == "" then
    return true
  end

  for _, ft_note in pairs({"text", "markdown", "vimwiki", "org", "tex", "plaintex"})  do
    if ft == ft_note then
      return true
    end
  end
  return false
end

vim.opt.undofile = false
vim.opt.swapfile = false
vim.opt.backup = false

if vim.api.nvim_create_autocmd ~= nil then
  vim.api.nvim_create_autocmd(
    {"BufRead", "BufNewFile", "BufNew"}, {
      pattern = {"*"},
      callback  = function ()
        local file_path = vim.fn.expand('%:p')
        if string.match(file_path, ".*/tmp/.*") ~= nil then
          return
        end

        local filetype = vim.opt_local.filetype:get()
        if filetype ~= "" then
          vim.opt_local.swapfile = true
        end
        if not is_note(filetype) then
          vim.opt_local.undofile = true
        end
      end
    }
  )
end


--------------------------------------------------------------------------------
--[[
 DISABLE Comment When insert new line (:help fo-table)
 set formatoptions-=r   " Enter
 set formatoptions-=o   " New line created by O
 set formatoptions-=c   " wrap comment using textwidth
-- autocmd FileType * setlocal formatoptions-=r formatoptions-=o
 그냥 set 으로 설정하면 안먹힘. (2022-04-14)
    - 아마도 override 하는 플러그인이 있을터
--]]

-- defaults: tcqj (2022-05-15)
-- jcroql -- override by something?
vim.opt.formatoptions = "tcqjprn"
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


-------------------------------------------------------------------------------
-- DISABLE AUTO Word Break
-------------------------------------------------------------------------------
-- https://vim.fandom.com/wiki/Word_wrap_without_line_breaks
vim.opt.wrap = true
vim.opt.textwidth=0

-------------------------------------------------------------------------------
-- complete: set the matches for insert mode completion
-- default: .wbut ?
vim.opt.complete = ".,w,b,u,t,i"
