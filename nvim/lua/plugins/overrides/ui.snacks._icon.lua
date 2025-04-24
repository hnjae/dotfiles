local icons = require("globals").icons

---@type LazySpec
return {
  [1] = "snacks.nvim",
  optional = true,
  ---@type snacks.Config
  opts = {
    toggle = {
      icon = {
        enabled = icons.toggle_on,
        disabled = icons.toggle,
      },
    },
  },
}
