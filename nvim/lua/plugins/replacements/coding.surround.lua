--[[
  replacements of LazyExtra's `coding.mini-surround`

  차이점:
    - mini-surround:
      - `sa`, `sd`, `sr` 등의 맵핑 사용.
      - LazyVim 에서는 `s` 가 이미 선점되어 있으므로, `gsa`, `gsd`, `gsr` 로 제공
]]
-- NOTE: use S in visual-mode <2024-05-09>

---@type LazySpec
return {
  [1] = "kylechui/nvim-surround",
  lazy = true,
  version = "*",
  event = { "VeryLazy" },
  opts = {},
  dependencies = {
    -- to override keys of flash.nvim
    { [1] = "flash.nvim", optional = true },
  },
  specs = {},
}
