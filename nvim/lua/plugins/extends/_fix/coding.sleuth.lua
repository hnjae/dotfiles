-- 자동으로 expandtab/shiftwidth 인식
-- editorconfig 존중

-- ftplugin/<foo>.lua 가 무시되는데?? 2025-06-08

---@type LazySpec
return {
  [1] = "tpope/vim-sleuth",
  version = false,

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
