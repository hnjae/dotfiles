-- http://lua-users.org/wiki/LuaStyleGuide
-- https://github.com/luarocks/lua-style-guide

vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
-- vim.opt_local.colorcolumn = vim.fn.join(vim.fn.range(81, 999), ",")


-- 여기서 lspconfig 설정하면 먹질 않음.
if packer_plugins['coc.nvim'] and packer_plugins['coc.nvim'].loaded then
  ----------------------------------------------------------------
  -- Formatting (==)
  ----------------------------------------------------------------
  vim.api.nvim_buf_set_keymap(0, "x", "==", "<plug>(coc-format-selected)", {})
  vim.api.nvim_buf_set_keymap(0, "n", "==", "<plug>(coc-format)", {})
end
-- 여기서 lspconfig 설정하면 먹질 않음.
