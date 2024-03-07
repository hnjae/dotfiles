local extension = {
  sections = {
    lualine_c = {
      require("plugins.ui.lualine.components.filename"),
    },
  },
  inactive_sections = {
    lualine_c = {
      require("plugins.ui.lualine.components.filename"),
    },
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
