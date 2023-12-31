return {
  sections = {
    lualine_a = {
      {
        function()
          return " "
        end,
      },
    },
    lualine_c = { "filename" },
    lualine_x = { "filetype" },
    lualine_y = {},
    lualine_z = { "location", "progress" },
  },
  inactive_sections = {
    lualine_c = { "filename" },
    lualine_x = { "filetype" },
    lualine_z = { "location" },
  },
  filetypes = { "help" },
}
