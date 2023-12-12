return {
  function()
    -- for _, lang in ipairs(vim.opt_local.spelllang:get()) do
    -- end
    return "on"
  end,
  icon = "󰓆",
  cond = function()
    return vim.opt_local.spell:get()
  end,
}
