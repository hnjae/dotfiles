local M = {}

M.prefix = {
  lang = "s",
  tab = "<Leader>nt",
  edit = "<Leader>ne",
  window = "<Leader>nw",
  sidebar = "<Leader>s",
  open = "<F6>",
  finder = "<F3>",
  sniprun = "<Leader>f",
  repl = "<Leader>r",
  close = "Z",
}

M.root_patterns = {
  ".editorconfig",
  ".neoconf.json",
  ".nlsp-settings",
  "pyproject.toml",
  "selene.toml",
  "stylua.toml",
  "vim.toml",
  ".git",
}

M.treesitter_fts = {
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
  -- "bash",
  -- "fish",
  -- "yaml",
  -- "toml",
  "gitcommit",
  "git_rebase",
  "gitattributes",
  "gitignore",
  -- "json",
  -- "jsonc",
  -- "json5",
  "html",
  "markdown",
  "latex",
  "bibtex",
  "dockerfile",
  "regex",
  "vim",
  "sql",
}

return M
