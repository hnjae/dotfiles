-- http://lua-users.org/wiki/LuaStyleGuide
-- https://github.com/luarocks/lua-style-guide

vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.colorcolumn = vim.fn.join(vim.fn.range(81, 999), ",")
-- vim.opt_local.formatoptions:remove("r")
-- vim.opt_local.formatoptions:remove("o")


-- 여기서 lspconfig 설정하면 먹질 않음.
if _IS_PLUGIN('coc.nvim') then
  ----------------------------------------------------------------
  -- Formatting (==)
  ----------------------------------------------------------------
  vim.api.nvim_buf_set_keymap(0, "x", "==", "<plug>(coc-format-selected)", {})
  vim.api.nvim_buf_set_keymap(0, "n", "==", "<plug>(coc-format)", {})
end
