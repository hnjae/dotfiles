vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- restore to vim's default
vim.opt.clipboard = "" -- do not sync with system clipboard
vim.opt.conceallevel = 0

-- tab's and indent
vim.opt.expandtab = false
vim.opt.tabstop = 8
vim.opt.shiftwidth = 8
vim.opt.shiftround = false -- true: round indent
-- vim.opt.list = false -- show whitespace, tabs, etc
-- vim.o.splitright = false

-- lazyvim config
vim.g.snacks_animate = false
vim.g.lazyvim_picker = "fzf" -- default in v14.14.0
-- vim.g.trouble_lualine = true
-- vim.g.lazyvim_picker = "telescope"
-- vim.g.lazyvim_picker = "snacks"

-- lang
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_prettier_needs_config = true
