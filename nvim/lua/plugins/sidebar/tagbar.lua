local prefix = require("val").prefix
local map_keyword = require("val").map_keyword

---@type LazySpec
return {
  [1] = "preservim/tagbar",
  lazy = true,
  enabled = vim.fn.executable("ctags") == 1,
  cmd = {
    "TagbarToggle",
  },
  keys = {
    {
      [1] = "[" .. map_keyword.tag,
      [2] = "<cmd>TagbarJumpPrev<CR>",
      desc = "prev-tag",
    },
    {
      [1] = "]" .. map_keyword.tag,
      [2] = "<cmd>TagbarJumpNext<CR>",
      desc = "next-tag",
    },
    {
      [1] = prefix.sidebar .. map_keyword.tag,
      [2] = "<cmd>TagbarToggle<CR>",
      desc = "tagbar",
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      [1] = "ludovicchabant/vim-gutentags",
      init = function()
        vim.g.gutentags_cache_dir = require("plenary.path"):new(
          vim.fn.stdpath("cache"),
          "gutentags"
        ).filename
        vim.g.gutentags_exclude_filetypes = {
          "",
          "fugitive",
          "NeogitStatus",
          "NeogitPopup",
          "nerdtree",
          "NvimTree",
          "tagbar",
          "Outline",
          "help",
          "startify",
          "alpha",
          "Trouble",
          "noice",
          "checkhealth",
          "qf",
          "dbui",
          "dbout",
        }
      end,
    },
  },
  init = function()
    vim.g.tagbar_width = 26 -- default: 40
    vim.g.tagbar_wrap = 0
    vim.g.tagbar_zoomwidth = 0 -- default 1 (use maximum width)
    vim.g.tagbar_indent = 1
    vim.g.tagbar_show_data_type = 1
    vim.g.tagbar_help_visiblity = 1
    vim.g.tagbar_show_balloon = 1
  end,
  config = function() end,
}
