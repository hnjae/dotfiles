-- <https://github.com/ltex-plus/ltex-ls-plus>
-- Supported markup languages: BibTEX, ConTEXt, Git commit messages, LATEX, Markdown, MDX, Typst, AsciiDoc, Org, Neorg, Quarto, reStructuredText, R Markdown, R Sweave, XHTML

---@type LazySpec
return {
  [1] = "neovim/nvim-lspconfig",
  optional = true,
  opts = {
    servers = {
      ltex_plus = {
        enabled = true,
      },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "ltex-ls-plus" } },
    },
  },
}
