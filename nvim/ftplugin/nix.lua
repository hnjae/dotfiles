vim.opt_local.textwidth = 80

-- indent
-- NOTE: treesitter of nix does not support indent <2024-04-25>
vim.opt_local.cindent = false
vim.opt_local.autoindent = true -- 여러줄 string 선언할때 필요
vim.opt_local.smartindent = false
