local filename = function()
  return " " .. vim.fn.FugitiveHead()
end

local fugitive = {
  sections = {
    lualine_a = { { filename } },
  },
  inactive_sections = {
    lualine_a = { { filename } },
  },
  filetypes = { "fugitive" },
}

return vim.tbl_extend(
  "keep",
  require("plugins.ui.lualine.extensions.basic"),
  fugitive
)
