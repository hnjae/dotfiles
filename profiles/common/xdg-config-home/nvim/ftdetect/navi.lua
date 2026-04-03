-- navi
-- https://github.com/denisidoro/navi/blob/master/docs/cheatsheet_syntax.md
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.cheat",
  callback = function()
    vim.opt_local.filetype = "navi"
    vim.opt_local.commentstring = "; %s"
  end,
})
