-- To List Filetype: :set filetype? or :set ft?

-- local _ft_c = function()
  vim.opt_local.autoindent = false
  vim.opt_local.smartindent = false
  vim.opt_local.cindent = true
  vim.opt_local.foldmethod = "syntax"
  vim.opt_local.foldlevel = 99
  vim.opt_local.colorcolumn = vim.fn.join(vim.fn.range(81, 999), ",")
-- end

-- vim.api.nvim_create_autocmd(
--   "FileType", {
--     pattern  = {"c", "cpp"},
--     callback = _ft_c
--   }
-- )

--------------------------------------------------------------------------
-- autocmd Filetype c,cpp setlocal colorcolumn=79
-- autocmd Filetype c,cpp map  <F9>  :! gcc -lm -W "%" -o "%.out"
-- autocmd Filetype c,cpp map  <F10> :! "./%.out"
-- autocmd Filetype c,cpp setlocal colorcolumn=81
-- autocmd Filetype c,cpp setlocal noautoindent
-- autocmd Filetype c,cpp setlocal nosmartindent
-- autocmd Filetype c,cpp setlocal cindent
-- autocmd Filetype c,cpp setlocal foldmethod=syntax
-- autocmd Filetype c,cpp setlocal foldlevel=99
-- autocmd Filetype c,cpp setlocal shiftwidth=4
-- autocmd Filetype c,cpp setlocal softtabstop=4
-- autocmd Filetype c,cpp setlocal expandtab
-- autocmd Filetype c,cpp setlocal colorcolumn=81
-- autocmd Filetype c,cpp let &colorcolumn=join(range(81,999),",")
