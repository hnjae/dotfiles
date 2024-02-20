local name = function()
  return vim.fn.winwidth(0) > 8 and "MINIMAP" or "MAP"
end

return {
  sections = {
    lualine_c = {
      name,
    },
  },
  inactive_sections = {
    lualine_c = {
      name,
    },
  },
  filetypes = { "minimap" },
}
