local ensure_installed = {
  "typescript",
  "c",
  "cmake",
  "make",
  "rust",
  "java",
  "kotlin",
  "lua",
  "python",
  "go",
  "bash",
  "fish",
  "yaml",
  "toml",
  "gitcommit",
  "git_rebase",
  "gitattributes",
  "gitignore",
  "json",
  "jsonc",
  "json5",
  "html",
  "markdown",
  "latex",
  "bibtex",
  "dockerfile",
  "regex",
  "vim",
  "sql",
}

return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    { "mrjones2014/nvim-ts-rainbow", module = true },
  },
  build = ":TSUpdate",
  lazy = true,
  enabled = true,
  ft = ensure_installed,
  -- event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = ensure_installed,
    highlights = { enable = true },
    rainbow = {
      enable = true,
      -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
      extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
      max_file_lines = 10000, -- Do not enable for files with more than n lines, int
    },
  },
  config = function(_, opts)
    -- make first paren fg_color
    local fg_color = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("StatusLine")), "fg")
    vim.cmd('exec "hi rainbowcol1 guifg=' .. fg_color .. '"')
    require("nvim-treesitter.configs").setup(opts)
  end,
}
