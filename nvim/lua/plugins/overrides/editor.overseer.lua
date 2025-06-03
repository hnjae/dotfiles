local wk_icon = {
  icon = "󰑮 ", -- nf-md-run_fast (from overseer.nvim)
  color = "blue",
}

---@type LazySpec
return {
  [1] = "overseer.nvim",
  optional = true,
  specs = {
    {
      [1] = "which-key.nvim",
      optional = true,
      opts = {
        ---@type wk.IconRule[]
        icons = {
          rules = {
            { plugin = "overseer.nvim", icon = wk_icon.icon, color = wk_icon.color },
          },
        },
        ---@type wk.Spec[]
        spec = {
          { [1] = "<Leader>o", group = "overseer", mode = { "n" }, icon = wk_icon },
        },
      },
    },
  },
}
