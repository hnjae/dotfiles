-- nvim-qt 에서는 안먹는 것 같다.
if vim.fn.has("gui_running") == 1 then
  vim.o.guifont = "monospace:h10"
end

-- VIM Mode 에 따라 커서 Shape 바뀌는 옵션 해제
-- vim.opt.guicursor = ""
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:block,r-cr-o:block"

-- show whitespace, tabs, etc
vim.opt.list = true
vim.opt.listchars = "tab:  ,nbsp:+"
-- vim.opt.listchars = "tab:>-,nbsp:+"
-- vim.opt.listchars = "tab:> ,nbsp:+,lead:␣"

if vim.fn.has("termguicolors") == 1 and not require("utils").is_console then
  vim.opt.termguicolors = true
end

-- if vim.g.neovide then
-- ~/.config/neovide/config.toml 에서 설정하자.
-- vim.opt.guifont = "monospace:h11"

-- vim.opt.guifont = "MesloLGM Nerd Font Mono:h11,monospace:h11"
-- vim.opt.guifont = "D2Coding:h11"
-- end

-- vim.opt.numberwidth = 1 -- default 4 (line number 표기 width; padding 포함)
-- vim.opt.sidescrolloff = 1 -- lazyvim 이 8 로 설정; 이거 적용되는거 맞음?

-- vim.opt.signcolumn = "yes"
-- vim.opt.statuscolumn = ""
