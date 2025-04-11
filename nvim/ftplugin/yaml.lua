vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

-- use nvim-treesitter instead
vim.opt_local.autoindent = false
vim.opt_local.cindent = false
vim.opt_local.smartindent = false

--
vim.opt_local.wrap = false
vim.opt_local.linebreak = false
vim.opt_local.textwidth = 0

-- vim.opt_local.filetype = "yaml.ansible"
-- if vim.fn.expand("%:t") == "docker-compose.yml" then
--   vim.api.nvim_buf_set_option(0, "ft", "yaml.docker-compose")
-- end
