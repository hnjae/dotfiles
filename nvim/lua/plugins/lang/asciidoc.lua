---@type LazySpec
return {
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
      "kotlin",
      "sh",
      "ruby",
      "dockerfile",
      "sql",
      "c",
      "nix",
      "typescript",
      "javascript",
    }
    vim.g.asciidoctor_syntax_conceal = 1
  end,
}
