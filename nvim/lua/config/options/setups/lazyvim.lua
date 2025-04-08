vim.g.mapleader = " "
vim.g.maplocalleader = "s"

-- disable clipboard
vim.opt.clipboard = ""

vim.g.snacks_animate = false

-- select default plugins (fzf, telescope, snacks)
vim.g.lazyvim_picker = "fzf" -- default in v14.14.0

-- lang
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_prettier_needs_config = true
