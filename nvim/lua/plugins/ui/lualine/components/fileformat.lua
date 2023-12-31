return {
  [1] = "fileformat",
  cond = function()
    return vim.opt_local.fileformat:get() ~= "unix"
  end,
}
