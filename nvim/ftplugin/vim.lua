-- To List Filetype: :set filetype? or :set ft?

vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.foldmethod = "marker"
vim.opt_local.foldlevel = 0
vim.opt_local.colorcolumn = vim.fn.join(vim.fn.range(81, 999), ",")

-- local status_npairs, npairs = pcall(require, 'nvim-autopairs')
-- if status_npairs then
  -- npairs.remove_rule('"')
  -- npairs.remove_rule('"""')
-- end
