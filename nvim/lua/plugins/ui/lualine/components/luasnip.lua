local is_luasnip, luasnip = pcall(require, "luasnip")
if not is_luasnip then
  return { "" }
end

-- local modules = require("lualine_require").lazy_require({
--   sources = "luasnip",
-- })

return {
  [1] = function()
    if luasnip.locally_jumpable() then
      return "JUMPABLE"
    else
      return ""
    end
  end,
  icon = "",
  color = "Pmenu",
  -- Automatically updates active buffer color to match color of other components (will be overridden if buffers_color is set)
  use_mode_colors = false,
}
