-- 자동으로 expandtab/shiftwidth 인식
-- editorconfig 존중

---@type LazySpec
return {
  [1] = "tpope/vim-sleuth",
  version = false,
  -- cond = not vim.g.vscode,

  lazy = true,
  event = {
    -- "VeryLazy" 는 늦다.
    "BufNewFile",
    "BufReadPost",
    "BufFilePost",
  },
  init = function()
    vim.g.slueth_text_heuristics = 0
    vim.g.slueth_no_filetype_indent_on = 1
  end,
}
