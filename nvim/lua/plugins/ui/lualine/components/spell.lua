return {
  [1] = function()
    return "on"
  end,
  icon = "󰓆",
  cond = function()
    return vim.opt_local.spell:get()
  end,
}
