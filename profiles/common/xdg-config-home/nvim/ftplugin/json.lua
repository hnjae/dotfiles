-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

-- vim.opt_local.foldlevel = 9
-- vim.cmd([[syntax match Comment +\/\/.\+$+]])

vim.opt_local.wrap = true
vim.opt_local.linebreak = true -- 단어 중간 wrap 금지

-- indent (use treesitter)
vim.opt_local.cindent = false
vim.opt_local.autoindent = false
vim.opt_local.smartindent = false
