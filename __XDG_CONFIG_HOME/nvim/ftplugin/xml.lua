-- To List Filetype: :set filetype? or :set ft?

-- local _ft_ml = function()
	vim.opt_local.softtabstop = 2
	vim.opt_local.shiftwidth = 2
	vim.opt_local.expandtab = true
-- end

-- let g:xml_syntax_folding=1
-- 위 명령어 쓰였으나 help 에 존재하지 않음. (2022-04-14)

-- vim.api.nvim_create_autocmd(
--   "FileType", {
--     pattern  = {"xml", "yaml"},
--     callback = _ft_ml
--   }
-- )
