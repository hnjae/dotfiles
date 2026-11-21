-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

vim.g.rust_recommended_style = 0
vim.opt_local.textwidth = 99 -- https://gist.github.com/Robbepop/f88d896f859712384039813fab939172#file-rustfmt-toml-L28
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true

-- use treesitter
vim.opt_local.autoindent = false
vim.opt_local.smartindent = false
vim.opt_local.cindent = false
