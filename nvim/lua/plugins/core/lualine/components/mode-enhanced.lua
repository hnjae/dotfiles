return {
  [1] = function()
    -- if is_luasnip and luasnip.locally_jumpable() then
    -- if vim.fn.empty(vim.fn["UltiSnips#SnippetsInCurrentScope"]()) == 1 then
    --   return " JUMPABLE"
    -- end

    return vim.api.nvim_get_mode().mode
  end,
}
