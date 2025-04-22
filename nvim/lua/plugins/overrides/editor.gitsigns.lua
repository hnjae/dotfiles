local wk_icon = {
  icon = require("globals").icons.git,
  color = "orange",
}

---@type LazySpec
return {
  [1] = "gitsigns.nvim",
  optional = true,
  opts = {
    diff_opts = {
      vertical = true,
    },
  },
  specs = {
    {
      [1] = "which-key.nvim",
      optional = true,
      -- ---@type wk.Opts
      opts = {
        ---@type wk.IconRule[]
        icons = {
          rules = {
            { plugin = "gitsigns.nvim", icon = wk_icon.icon, color = wk_icon.color },
          },
        },
        ---@type wk.Spec[]
        specs = {
          -- Add missing icon from LazyVim v14.14.0 (2025-04-09)
          { [1] = "[h", mode = { "n" }, icon = wk_icon },
          { [1] = "]h", mode = { "n" }, icon = wk_icon },
          { [1] = "[H", mode = { "n" }, icon = wk_icon },
          { [1] = "]H", mode = { "n" }, icon = wk_icon },
        },
      },
    },
  },
}
