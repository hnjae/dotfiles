vim.opt_local.tabstop = 8
-- vim.opt_local.softtabstop = 4
-- vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = false
vim.opt_local.colorcolumn = "0"
vim.opt_local.conceallevel = 1
vim.opt.formatoptions:remove("r")
vim.opt.formatoptions:remove("o")

-- if _IS_PLUGIN('tagbar') then
--   vim.b.tagbar_show_data_type = 0
--   -- vim.b.tagbar_wrap = 2
--   vim.b.tagbar_indent = 1
--   -- vim.b.tagbar_compact = 0
--
--   -- vim.b.tagbar_position = "leftabove vertical"
--   vim.b.tagbar_width = 50
--   vim.b.tagbar_zoomwidth = 0
--
--   vim.b.tagbar_sort = 0
--   vim.b.tagbar_show_linenumbers = -1
--
--   -- vim.b.tagbar_highlight_follow_insert = 1
-- end

-- vim.opt_local.foldlevel = 10
-- require('user.lsp').setup({"ltex"})

-------------------------------------------------------------------------------
-- lsp
-------------------------------------------------------------------------------
-- if not _IS_PLUGIN('coc.nvim') then
--   require('user.lsp').setup({"ltex"})
-- end
