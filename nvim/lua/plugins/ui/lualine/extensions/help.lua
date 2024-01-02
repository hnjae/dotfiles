-- for non editable filetypes

local extension = {
  sections = {
    lualine_c = { "filename" },
  },
  inactive_sections = {
    lualine_c = { "filename" },
  },
  filetypes = {
    "help",
  },
}

return vim.tbl_deep_extend(
  "keep",
  require("plugins.ui.lualine.extensions.basic"),
  extension
)
