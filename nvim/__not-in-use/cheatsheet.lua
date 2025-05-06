-- navi 와는 다르다!
-- <https://github.com/cheat/cheatsheets?tab=readme-ov-file>
-- http://docopt.org/ syntax 사용을 권장.
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*/cheat/cheatsheets/*/*",
  callback = function()
    vim.opt_local.filetype = "cheatsheet"
  end,
})
