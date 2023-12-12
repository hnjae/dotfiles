return {
  sections = {
    lualine_a = {
      {
        function()
          return " "
        end,
      },
    },
    lualine_b = {},
    lualine_c = {
      function()
        return vim.b.netrw_curdir
      end,
    },
    lualine_x = { "filetype" },
    lualine_y = {},
    lualine_z = { "location", "progress" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = {},
    lualine_y = { "filetype" },
    lualine_z = {},
  },
  filetypes = {
    "netrw",
  },
}
