-- bash 는 sh 로 구분됨 (2022-04-14)
-- https://lug.fh-swf.de/vim/vim-bash/StyleGuideShell.en.pdf

vim.opt_local.softtabstop = 8
vim.opt_local.shiftwidth = 8
vim.opt_local.expandtab = false

-- indent
vim.opt_local.smartindent = false
vim.opt_local.autoindent = false
vim.opt_local.cindent = false

-- vim.opt_local.foldmethod = "marker"
-- vim.opt_local.colorcolumn = vim.fn.join(vim.fn.range(81, 999), ",")
