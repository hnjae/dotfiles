-- VIM Options : Indent
--------------------------------------------------------------------------------
-- List of Tab Options
-- set tabstop=4	 -- width of tabs
-- 	tabstop 이랑 shiftwidth 이랑 다르면 tab 한번에 두개의 /t 이 들아가는
-- 	일도 생김
-- softtabstop=int :
-- 	default value for tabstop | or set same value as shiftwidth
-- expandtab :
-- 	탭을 누르면 softtabstop 만큼의 스페이스로 입력한다.
-- set shiftwidth=8
--	int / affects what happens when you press >> << ==
vim.opt.smarttab = true

-- List of Indent Options
-- use treesitter's feature instead
vim.opt.smartindent = false
vim.opt.cindent = false
vim.opt.autoindent = false

-- set smartindent: automatically inserts one extra level of indentation in some case.
-- set cindent		: is more customizable, but also more strict when it comes to syntax.
-- set autoindent : does nothing more than copy the indentation from the previous line
