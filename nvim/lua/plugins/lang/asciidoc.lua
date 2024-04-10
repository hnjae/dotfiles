---@type LazySpec[]
return {
  {
    [1] = "habamax/vim-asciidoctor",
    lazy = true,
    enabled = true,
    ft = { "asciidoc", "asciidoctor" },
    cmd = {
      "AsciidoctorOpenRAW",
    },
    ---@type LazyKeysSpec[]
    keys = {
      {
        [1] = require("val").prefix.buffer .. "p",
        [2] = "<cmd>AsciidoctorOpenRAW<CR>",
        desc = "preview-asciidoc",
        ft = {
          "asciidoc",
          "asciidoctor",
        },
      },
    },
    init = function()
      -- NOTE: handlr can not handle asciidoc file.
      -- It recognize it as text file.
      local utils = require("utils")
      vim.g.asciidoctor_opener = "!" .. utils.get_browser_cmd()

      vim.g.asciidoctor_folding = 1
      vim.g.asciidoctor_syntax_indented = 1
      vim.g.asciidoctor_fenced_languages = {
        "html",
        "python",
        "java",
        -- "kotlin", -- requires styles/kotlin.vim
        "sh",
        "ruby",
        "dockerfile",
        "sql",
        "c",
        "nix",
        "typescript",
        "javascript",
      }
      --[[ NOTE: <2024-04-08>
    `asciidoctor_fenced_languages` 는 styles/<ft-name>.vim 를 요구하는 것 같음
    kotlin의 경우 syntax support 가 내장되어 있지 않아, 에러 메시지가 뜸.

    그러나 treesitter 에서 syntax 를 지원해서 별도로 설치 하지는 않을 예정.
    ]]
      vim.g.asciidoctor_syntax_conceal = 1
    end,
  },
  {
    [1] = "preservim/tagbar",
    optional = true,
    opts = function()
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
  },
}
