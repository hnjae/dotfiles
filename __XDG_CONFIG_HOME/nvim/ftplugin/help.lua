-- To List Filetype: :set filetype? or :set ft?

-- vim.opt_local 하면 에러 생김
-- local _ft_help = function()
vim.opt_local.number = true
vim.opt_local.relativenumber = true
-- end

-- vim.api.nvim_create_autocmd(
--   "FileType", {
--     pattern  = {"help"},
--     callback = _ft_help
--   }
-- )
