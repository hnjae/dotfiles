return {
  [1] = function()
    return vim.opt_local.fileformat:get()
  end,
  -- icon = "",
  cond = function()
    return vim.opt_local.fileformat:get() ~= "unix"
  end,
}
