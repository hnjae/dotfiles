-- https://github.com/denisidoro/navi/blob/master/docs/cheatsheet_syntax.md
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.cheat",
  callback = function()
    vim.opt_local.filetype = "sh"
  end,
  -- command = "set ft=sh",
})
