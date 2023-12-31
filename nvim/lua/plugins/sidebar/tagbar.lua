local prefix = require("val").prefix

---@type LazySpec
return {
  [1] = "preservim/tagbar",
  lazy = true,
  enabled = vim.fn.executable("ctags") == 1,
  cmd = {
    "TagbarToggle",
  },
  keys = {
    { [1] = "[t", [2] = "<cmd>TagbarJumpPrev<CR>", desc = "prev-tag" },
    { [1] = "]t", [2] = "<cmd>TagbarJumpNext<CR>", desc = "next-tag" },
    { [1] = prefix.sidebar .. "t", [2] = "<cmd>TagbarToggle<CR>", desc = "tagbar" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      [1] = "ludovicchabant/vim-gutentags",
      init = function()
        vim.g.gutentags_cache_dir = require("plenary.path"):new(vim.fn.stdpath("cache"), "gutentags").filename
        vim.g.gutentags_exclude_filetypes = {
          "",
          "fugitive",
          "nerdtree",
          "tagbar",
          "help",
        }
      end,
    },
  },
  config = function()
    vim.g.tagbar_width = 26 -- default: 40
    vim.g.tagbar_wrap = 0
    vim.g.tagbar_zoomwidth = 0 -- default 1 (use maximum width)
    vim.g.tagbar_indent = 1
    vim.g.tagbar_show_data_type = 1
    vim.g.tagbar_help_visiblity = 1
    vim.g.tagbar_show_balloon = 1

    vim.g.tagbar_type_asciidoctor = {
      ["sro"] = '""',
      ["sort"] = 0,
      ["ctagstype"] = "asciidoc",
      ["regex"] = {
        "/^(={1,6})[[:space:]\\t]+([^=]+)/\\1 \\2/h,header,AsciiDoctor Headers/",
      },
      ["kinds"] = {
        "h:headings",
      },
    }

    -- vim.g.tagbar_type_asciidoctor = {
    --   ["sro"] = '""',
    --   ["sort"] = 0,
    --   ["ctagstype"] = "asciidoc",
    --   ['kinds'] = {
    --     'c:chapter:0:1',
    --     's:section:0:1',
    --     'S:subsection:0:1',
    --     't:subsubsection:0:1',
    --     'T:paragraph:0:1',
    --     'u:subparagraph:0:1',
    --     -- 'a:anchor:0:1',
    --   },
    -- ['kind2scope'] = {
    --   ['c'] = 'chapter',
    --   ['s'] = 'section',
    --   ['S'] = 'subsection',
    --   ['t'] = 'subsubsection',
    --   ['T'] = 'l4subsection',
    --   ['u'] = 'l5subsection',
    --   -- ['a'] = 'anchor',
    -- },
    -- ['scope2kind'] = {
    --   ['chapter']       = 'c',
    --   ['section']       = 's',
    --   ['subsection']    = 'S',
    --   ['subsubsection'] = 't',
    --   ['l4subsection']  = 'T',
    --   ['l5subsection']  = 'u',
    --   -- ['anchor']        = 'a',
    -- },
    -- }
  end,
}
