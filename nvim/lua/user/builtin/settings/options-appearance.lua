-- nvim-qt 에서는 안먹는 것 같다.
-- if has("gui_running")
--     set guifont=Monospace:h11
-- endif

-- VIM Mode 에 따라 커서 Shape 바뀌는 옵션 해제
vim.opt.guicursor = ""

if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end

if vim.g.neovide then
  vim.opt.guifont = "monospace:h12"
  -- vim.opt.guifont = "MesloLGM Nerd Font Mono:h11,monospace:h11"
  -- vim.opt.guifont = "D2Coding:h11"
end

-- vim.opt.guifont = { "MesloLGS NF", "h2" }
-- vim.opt.guifont = "MesloLGS NF:h11,Noto Sans Mono CJK KR:h11"
-- vim.opt.guifont = "MesloLGS NF,Noto Sans Mono CJK KR:h11"
-- vim.opt.guifont = "MesloLGS NF,Pretendard:h11"
