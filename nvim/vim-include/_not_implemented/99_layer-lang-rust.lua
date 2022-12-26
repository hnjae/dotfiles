vim.cmd([[
autocmd FileType rust TagbarOpen
autocmd FileType rust let &colorcolumn=join(range(99,999),",")
]])

vim.g.rust_conceal = 0
vim.g.rust_conceal_mod_path = 0
vim.g.rust_conceal_pub = 0

-- Fold level are controlled  by globalvalue
vim.g.rust_fold = 2

-- vim.api.nvim_set_keymap('n', '<leader>mcc', '<cmd>:Cbuild<CR>', {})
-- call nvim_set_keymap('n', ' <NL>', '', {'nowait': v:true})
-- vim.api.nvim_set_keymap('n', 'k')
-- vim.g.which_key_map.c.c = 'build'
