local wk_icon = {
  icon = "󱤶 ", -- nf-md-cog_play_outline
  color = "blue",
}

---@type LazyPluginSpec
local spec = {
  [1] = "which-key.nvim",
  optional = true,
  -- LazyVim v15 registers the <leader>o group itself, so only customize icons here.
  opts = {
    ---@type wk.IconRule[]
    icons = {
      rules = {
        -- NOTE: 아래와 같이 설정하면 전부 덮어버림.
        -- { plugin = "overseer.nvim", icon = wk_icon.icon, color = wk_icon.color },
        { pattern = "overseer", icon = wk_icon.icon, color = wk_icon.color },
      },
    },
  },
}

---@type LazySpec
return {
  [1] = "overseer.nvim",
  optional = true,
  specs = { spec },
}
