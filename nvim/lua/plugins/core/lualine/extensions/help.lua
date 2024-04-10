local extension = {
  sections = {
    lualine_c = {
      require("plugins.core.lualine.components.filename"),
    },
  },
  inactive_sections = {
    lualine_c = {
      require("plugins.core.lualine.components.filename"),
    },
  },
  filetypes = {
    "help",
  },
}

return vim.tbl_deep_extend(
  "keep",
  require("plugins.core.lualine.extensions.basic"),
  extension
)
