vim.opt_local.tabstop = 8
vim.opt_local.expandtab = false

vim.opt_local.colorcolumn = "0"
vim.opt_local.conceallevel = 0

vim.opt.formatoptions:remove("r")
vim.opt.formatoptions:remove("o")

-- use treesitter
-- NOTE: treesitter 의 indent 기준을 모르겠음. autoindent 쓰자. <2024-01-09>
vim.opt_local.autoindent = true
vim.opt_local.smartindent = false
vim.opt_local.cindent = false
