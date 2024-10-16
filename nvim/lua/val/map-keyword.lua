-- Type Effort (colemak-dh):
-- 1.0 tn
-- 1.1 se
-- 1.3 ri
-- 1.6 ~ 1.8 aodh
-- 2.0 ~ 2.2 yflvk
-- 2.3 ~ 2.4 bycu,
-- 2.5~ 2.7 wbx.
-- 2.9 gm
-- 3.0 + l
-- 3+ bq;/j

-- 설정 전역에서 각종 키워드 통일 위해 사용.
---@type table<string, string>
return {
  -- 보통 특정 목적의 윈도우를 여는 식의 작업에 사용되길 기대.
  trouble = "x",
  filemanager = "e", -- tree, filemanager
  window = "w",
  terminal = "i",
  git = "g",
  ai = "y",

  --
  -- finder = "e", -- e.g. telescope, obsolate 2024-10-16, use find
  find = "e", -- e.g. telescope

  --
  execute = "x",

  -- 위와 미교하게 focus 가 다름
  focus = "F", -- deprecated 2024-02-19
  focus_picker = "f", -- focus window using s1n7ax/nvim-window-picker

  -- 아래는 위와 같은 scope 에서 쓰이지 않을걸로 기대됨.
  -- 특정 키워드를 찾거나 하는데 사용되길 기대.
  marks = "m",
  line = "e",
  lsp = "l",
  symbols = "y",
  -- snippet = "p",
  tag = "g",
  task = "t",
  diagnostics = "d",

  --
  current = "e",
  tab = "t",
  vsplit = "v",
  split = "x", -- telescope's default
  float = "f",

  --
  hover_scroll_up = "<C-k>", -- "<C-f>"
  hover_scroll_down = "<C-j>", -- "<C-j>"
}
