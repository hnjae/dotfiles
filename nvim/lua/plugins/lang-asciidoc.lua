return {
  [1] = "habamax/vim-asciidoctor",
  lazy = false,
  -- ft = { "asciidoc", "asciidoctor" },
  keys = {
    {
      [1] = require("val").prefix.lang .. "p",
      [2] = "<cmd>AsciidoctorOpenRAW<CR>",
      desc = "preview",
    },
  },
  init = function()
    -- NOTE: handlr can not handle asciidoc file.
    -- It recognize it as text file.
    local browser = os.getenv("BROWSER")
    if browser == nil then
      browser = "firefox"
    end

    local is_luasnip, luasnip = pcall(require, "luasnip")
    if is_luasnip then
      luasnip.filetype_extend("asciidoctor", { "asciidoc" })
    end

    vim.g.asciidoctor_opener = "!" .. browser

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
