-- nvim-qt 에서는 안먹는 것 같다.
-- if has("gui_running")
--     set guifont=Monospace:h11
-- endif

-- VIM Mode 에 따라 커서 Shape 바뀌는 옵션 해제
vim.opt.guicursor=""

if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end

------------------------------------------------------------------
-- https://github.com/tomasiser/vim-code-dark
vim.g.codedark_italics = 1
vim.cmd([[silent! colorscheme codedark]])

------------------------------------------------------------------
-- vim.g.adwaita_darker = true -- for darker version
-- vim.g.adwaita_disable_cursorline = true -- to disable cursorline
-- vim.cmd([[silent! colorscheme adwaita]])
------------------------------------------------------------------
-- vim.g.rasmus_italic_functions = true
-- vim.g.rasmus_bold_functions = true
-- vim.g.rasmus_variant = "dark"
-- vim.cmd([[silent! colorscheme rasmus]])

------------------------------------------------------------------
-- vscode.nvim
-- does not support htmlH1 (2022-06-21)
-- vim.g.vscode_style = "dark"
-- vim.g.vscode_italic_comment = 1
-- vim.cmd([[silent! colorscheme vscode]])
------------------------------------------------------------------
-- vim.g.material_style = "darker"
-- vim.cmd([[silent! colorscheme material]])

------------------------------------------------------------------
--   -- vim.g.airline_theme='tender' -- 자동으로 해줌.
--   vim.cmd([[colorscheme tender]])
------------------------------------------------------------------
--   vim.cmd([[silent! colorscheme jellybeans]])
--   vim.g.jellybeans_use_term_italics = 1
--   vim.g.jellybeans_use_lowcolor_black = 0
--   vim.g.airline_theme='jellybeans'
------------------------------------------------------------------
-- vim.cmd([[silent! colorscheme gruvbox]])
--   vim.g.gruvbox_italic=1
--   vim.g.gruvbox_contrast_light='soft'
--   vim.g.gruvbox_contrast_dark='hard'
--   vim.g.airline_theme='gruvbox'
------------------------------------------------------------------
-- local status_theme, github_theme = pcall(require, "github-theme")
-- if status_theme then
--   github_theme.setup({
--     theme_style = "dark_default",
--     function_style = "italic",
--   })
-- end

------------------------------------------------------------------
-- vim.g.vscode_style = "dark"
-- vim.g.vscode_transparent = 0
-- vim.g.vscode_italic_comment = 1
-- -- Disable nvim-tree background color
-- -- vim.g.vscode_disable_nvimtree_bg = true
-- vim.cmd([[silent! colorscheme vscode]])
------------------------------------------------------------------
-- neon
-- vim.g.neon_style="dark"
-- vim.g.neon_italic_keyword=true
-- vim.cmd[[silent! colorscheme neon]]

-- vim.cmd[[silent! colorscheme dracula]]
-- vim.g.dracula_bold = 1
-- vim.g.dracula_italic = 1
-- vim.g.dracula_underline = 1
