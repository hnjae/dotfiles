---@type LazySpec
return {
  [1] = "tpope/vim-vinegar",
  lazy = true,
  enabled = true,
  -- netrw 효과 없음
  -- ft = {
  --   "netrw",
  -- },
  event = {
    "BufEnter",
  },
  keys = {
    { [1] = "-", [2] = nil, desc = "vinegar-up" },
  },
}
