-- nvim-qt 에서는 안먹는 것 같다.
-- if has("gui_running")
--     set guifont=Monospace:h11
-- endif

-- VIM Mode 에 따라 커서 Shape 바뀌는 옵션 해제
vim.opt.guicursor = ""

if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end

vim.opt.guifont = { "MesloLGS NF", "h14" }
-- if vim.fn.exists("g:neovide")
-- if false and vim.fn.has('nvim-0.7') == 1 then
-- vim.opt.neovide_refresh_rate= 30
-- end
