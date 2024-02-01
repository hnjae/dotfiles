local is_luasnip, luasnip = pcall(require, "luasnip")

return {
  [1] = function()
    if is_luasnip and luasnip.locally_jumpable() then
      return " JUMPABLE"
    end

    return vim.api.nvim_get_mode().mode
  end,
}
