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
    "VimEnter",
    -- VeryLazy 보다는 빨라야함
  },
  keys = {
    { [1] = "-", [2] = nil, desc = "vinegar-up" },
  },
}
