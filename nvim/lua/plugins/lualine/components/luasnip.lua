local status_luasnip, luasnip = pcall(require, "luasnip")
return {
  function()
    if luasnip.locally_jumpable() then
      return "JUMPABLE"
    else
      return ""
    end
  end,
  icon = "",
  cond = function()
    return status_luasnip
  end,
  color = "Pmenu",
  -- Automatically updates active buffer color to match color of other components (will be overridden if buffers_color is set)
  use_mode_colors = false,
}
