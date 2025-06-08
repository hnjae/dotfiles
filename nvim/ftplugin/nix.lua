vim.opt_local.textwidth = 100 -- nixfmt's default

vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

-- NOTE: treesitter indent 가 별로이니, autoindent 쓰자. <2025-01-24>
vim.opt_local.cindent = false
vim.opt_local.autoindent = true
vim.opt_local.smartindent = false

-- vim.opt_local.matchpairs:remove([[':']])
-- vim.opt_local.matchpairs:append([['':'']])
