local icon = require("utils").use_icons and require("globals").icons.lightbulb
  or "!"

-- TODO: WIP <2024-07-26>
---@type LazySpec
return {
  [1] = "kosayoda/nvim-lightbulb",
  lazy = true,
  cond = not vim.g.vscode,
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
