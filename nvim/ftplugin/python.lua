vim.opt_local.textwidth = 79

-- use treesitter
vim.opt_local.autoindent = false
vim.opt_local.smartindent = false
vim.opt_local.cindent = false

-- https://develop.spacemacs.org/layers/+lang/python/README.html
-- autocmd Filetype python setlocal python_highlight_all=1
-- let python_highlight_all=1 " 이거 키면 공백이 하이라이트 되는 게 짜증나
-- let python_space_error_highlight=0
-- let python_highlight_space_errors = 0

-------------------------------------------------------------------------------
-- Indent & Colorcolumn
-------------------------------------------------------------------------------
-- indent 관련 설정은 python-mode 에서 함.
-- vim.opt_local.softtabstop = 4
-- vim.opt_local.shiftwidth = 4
-- vim.opt_local.expandtab = true
-- vim.opt_local.autoindent = false
-- vim.opt_local.cindent = false
-- vim.opt_local.smartindent = false
-- vim.opt_local.foldmethod = "indent"
-- vim.opt_local.foldlevel = 9
-- vim.opt_local.colorcolumn = vim.fn.join(vim.fn.range(80, 999), ",")
--
