return {
  "fileformat",
  cond = function()
    return vim.opt_local.fileformat:get() ~= "unix"
  end,
}
