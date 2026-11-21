-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

-- navi
-- https://github.com/denisidoro/navi/blob/master/docs/cheatsheet_syntax.md
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.cheat",
  callback = function()
    vim.opt_local.filetype = "navi"
    vim.opt_local.commentstring = "; %s"
  end,
})
