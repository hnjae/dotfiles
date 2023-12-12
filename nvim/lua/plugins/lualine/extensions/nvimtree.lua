return {
  sections = {
    lualine_a = {
      {
        function()
          return " "
        end,
      },
    },
    lualine_c = {
      {
        function()
          return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
        end,
      },
    },
  },
  inactive_sections = {
    lualine_c = { "filetype" },
  },
  filetypes = { "NvimTree" },
}
