-- To List Filetype: :set filetype? or :set ft?
-- bash 는 sh 로 구분됨 (2022-04-14)
-- https://lug.fh-swf.de/vim/vim-bash/StyleGuideShell.en.pdf

vim.opt_local.autoindent = false
vim.opt_local.cindent = false
vim.opt_local.smartindent = true
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.foldmethod = "marker"
vim.opt_local.colorcolumn = vim.fn.join(vim.fn.range(81, 999), ",")

-- local status_ok, lsp = pcall(require, "user.lsp")
-- if status_ok then
--   lsp.setup({"bashls"})
-- end
