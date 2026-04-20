local wk_icon = {
  icon = "󱤶 ", -- nf-md-cog_play_outline
  color = "blue",
}

---@type LazyPluginSpec
local spec = {
  [1] = "which-key.nvim",
  optional = true,
  opts = {
    ---@type wk.IconRule[]
    icons = {
      rules = {
        -- NOTE: 아래와 같이 설정하면 전부 덮어버림.
        -- { plugin = "overseer.nvim", icon = wk_icon.icon, color = wk_icon.color },
      },
    },
    ---@type wk.Spec[]
    -- <leader>o: LazyVim 14 기준 맵핑
    spec = {
      { [1] = "<Leader>o", group = "overseer", mode = { "n" }, icon = wk_icon },
    },
  },
}

---@type LazySpec
return {
  [1] = "overseer.nvim",
  optional = true,
  specs = { spec },
}
