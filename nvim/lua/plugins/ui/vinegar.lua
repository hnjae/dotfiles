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
    -- "VimEnter",
    -- VeryLazy 보다는 빨라야함
    -- 타 netrw 대체 프로그램 사용하므로 event 끔. - 키 할당 기능만을 위해 사용.
  },
  keys = {
    { [1] = "-", [2] = nil, desc = "vinegar-up" },
  },
}
