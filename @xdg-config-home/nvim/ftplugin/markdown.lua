-- obsidian
vim.opt_local.shiftwidth = 4 -- sw=4 가 되어야지, ordered list 와 unordered list 가 제대로 indent 됨.
vim.opt_local.expandtab = true

vim.opt_local.conceallevel = 1
vim.opt_local.colorcolumn = "0"
vim.opt_local.wrap = true
vim.opt_local.linebreak = true -- 단어 중간 wrap 금지
vim.opt_local.list = false

-- use treesitter
-- NOTE: treesitter 의 indent 기준을 모르겠음. autoindent 쓰자. <2024-01-09>
-- vim.opt_local.autoindent = true
-- vim.opt_local.smartindent = false
-- vim.opt_local.cindent = false
