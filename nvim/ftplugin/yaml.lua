-- To List Filetype: :set filetype? or :set ft?

vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

-- indent option check needed (2022-07-09)
vim.opt_local.autoindent = true
vim.opt_local.cindent = false
vim.opt_local.smartindent = false

-- vim.opt_local.filetype = "yaml.ansible"

if vim.fn.expand('%:t') == "docker-compose.yml" then
  vim.api.nvim_buf_set_option(0, "ft", "yaml.docker-compose")
end
