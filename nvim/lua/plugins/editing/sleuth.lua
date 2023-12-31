-- 자동으로 expandtab/shiftwidth 인식
-- editorconfig 존중
return {
  [1] = "tpope/vim-sleuth",
  lazy = true,
  enabled = true,
  event = {
    "BufNewFile",
    "BufReadPost",
    "BufFilePost",
  },
  init = function()
    vim.g.slueth_text_heuristics = 0
    vim.g.slueth_no_filetype_indint_on = 1
  end,
}
