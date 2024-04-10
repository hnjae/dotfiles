return {
  [1] = "encoding",
  -- icon = "󰻐",
  cond = function()
    return vim.opt_local.encoding:get() ~= "utf-8"
  end,
}
