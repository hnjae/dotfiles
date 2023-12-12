return {
  sections = {
    lualine_a = { "mode" },
    lualine_c = {
      {
        function()
          return " " .. vim.fn.FugitiveHead()
        end,
      },
    },
    lualine_x = { "filetype" },
    lualine_y = {},
    lualine_z = { "location", "progress" },
  },
  inactive_sections = {
    -- lualine_c = { 'filetype' },
    lualine_c = {
      {
        function()
          return " " .. vim.fn.FugitiveHead()
        end,
      },
    },
    lualine_x = { "location" },
  },
  filetypes = { "fugitive" },
}
