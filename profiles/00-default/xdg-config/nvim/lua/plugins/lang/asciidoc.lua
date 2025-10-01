-- TODO: map preview at <leader>cp <2025-04-10>
---@type LazySpec[]
return {
  -- TODO: add asciidoc parser to treesitter (treesitter 가 버전업 하면서 기존 설정이 망가짐. nvim 설정이 아니라 tree-sitter cli 툴로 파서를 설치해야하는 것 같은데...) <2025-10-01>
  -- {
  --   "nvim-treesitter",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.ensure_installed = opts.ensure_installed or {}
  --   end,
  -- },
  {
    [1] = "habamax/vim-asciidoctor",
    version = false,
    lazy = true,
    cond = false,
    ft = { "asciidoc", "asciidoctor" },
    cmd = {
      "AsciidoctorOpenRAW",
    },
    ---@type LazyKeysSpec[]
    keys = {
      --[[ {
        [1] = require("globals").prefix.buffer .. "p",
        [2] = "<cmd>AsciidoctorOpenRAW<CR>",
        desc = "preview-asciidoc",
        ft = {
          "asciidoc",
          "asciidoctor",
        },
      }, ]]
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
    kotlin 의 경우 syntax support 가 내장되어 있지 않아, 에러 메시지가 뜸.

    그러나 treesitter 에서 syntax 를 지원해서 별도로 설치 하지는 않을 예정.
    ]]
      vim.g.asciidoctor_syntax_conceal = 1
    end,
  },
  -- {
  --   [1] = "tagbar",
  --   optional = true,
  --   ft = { "asciidoc", "asciidoctor" },
  -- },
  -- {
  --   [1] = "vim-gutentags",
  --   optional = true,
  --   ft = { "asciidoc", "asciidoctor" },
  -- },
}
