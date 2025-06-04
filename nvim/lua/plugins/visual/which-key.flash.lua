local wk_icon = {
  icon = "󰛕 ", -- nf-md-flash_outline
}

---@type LazySpec
return {
  [1] = "flash.nvim",
  optional = true,
  specs = {
    {
      [1] = "which-key.nvim",
      optional = true,
      opts = {
        ---@type wk.IconRule[]
        icons = {
          rules = {
            { plugin = "flash.nvim", icon = wk_icon.icon },
          },
        },
      },
    },
  },
}
