--[[
  replacements of LazyExtra's `coding.mini-surround`

  차이점:
    - mini-surround:
      - `sa`, `sd`, `sr` 등의 맵핑 사용.
      - LazyVim 에서는 `s` 가 이미 선점되어 있으므로, `gsa`, `gsd`, `gsr` 로 제공

  - 현재 flash.nvim 과 충돌. flash.nvim 의 textobject 를 사용하기 위해서는, which-key 윈도우 호출 후 사용 가능.
]]
-- NOTE: use S in visual-mode <2024-05-09>

local wk_icon = {
  icon = "󰨾 ", -- nf-md-contain
  color = "cyan",
}

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
  specs = {
    {
      [1] = "which-key.nvim",
      optional = true,
      opts = {
        ---@type wk.IconRule[]
        icons = {
          rules = {
            { plugin = "nvim-surround", icon = wk_icon.icon, color = wk_icon.color },
          },
        },
        ---@type wk.Spec[]
        spec = {
          { [1] = "S", mode = { "x" }, icon = wk_icon },
        },
      },
    },
  },
}
