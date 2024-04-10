return {
  [1] = function()
    return "on"
  end,
  icon = require("utils").enable_icon and "" or "󰓆",
  cond = function()
    return vim.opt_local.spell:get()
  end,
}
