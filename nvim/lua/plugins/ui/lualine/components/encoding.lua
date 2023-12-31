return {
  [1] = "encoding",
  cond = function()
    return vim.opt_local.encoding:get() ~= "utf-8"
  end,
}
