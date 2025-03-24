-- 자동으로 expandtab/shiftwidth 인식
-- editorconfig 존중

---@type LazySpec
return {
  [1] = "tpope/vim-sleuth",
  lazy = true,
  enabled = true,
  cond = not vim.g.vscode,
  event = {
    -- TODO: VeryLazy 해도 작동하는지 <2024-01-19>
    "BufNewFile",
    "BufReadPost",
    "BufFilePost",
  },
  init = function()
    vim.g.slueth_text_heuristics = 0
    vim.g.slueth_no_filetype_indent_on = 1
  end,
}
