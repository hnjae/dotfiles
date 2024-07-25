local icon = require("utils").enable_icon and require("val").icons.lightbulb
  or "!"

-- TODO: WIP <2024-07-26>
---@type LazySpec
return {
  [1] = "kosayoda/nvim-lightbulb",
  lazy = true,
  event = { "LspAttach" },
  opts = {
    sign = {
      text = icon,
    },
    virtual_text = {
      enabled = true,
      text = icon,
    },
    float = {
      enabled = true,
      text = icon,
    },
    status_text = {
      enabled = true,
      text = icon,
    },
  },
}
