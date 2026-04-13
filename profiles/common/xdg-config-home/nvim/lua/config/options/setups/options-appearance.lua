-- nvim-qt 에서는 안먹는 것 같다.
if vim.fn.has("gui_running") == 1 then
  vim.o.guifont = "monospace:h11"
end

vim.api.nvim_set_option_value("background", "light", {})

-- vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:block,r-cr-o:block" VIM Mode 에 따라 커서 Shape 바뀌는 옵션 해제
-- vim.opt.guicursor = "n-v-c-sm:block/Cursor,i-ci-ve:block/Cursor,r-cr-o:block/Cursor"
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:Cursor/lCursor,sm:block"

-- show whitespace, tabs, etc
vim.opt.list = true
vim.opt.listchars = "tab:  ,nbsp:+"

vim.opt.termguicolors = vim.fn.has("termguicolors") == 1 and os.getenv("XDG_SESSION_TYPE") ~= "tty"
