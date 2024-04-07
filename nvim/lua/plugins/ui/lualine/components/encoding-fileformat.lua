return {
  [1] = function()
    local fileformat = vim.opt_local.fileformat:get()
    local encoding = vim.opt_local.encoding:get()

    if encoding == "utf-8" and fileformat == "unix" then
      return ""
    end

    return string.format("%s [%s]", encoding, fileformat)
  end,
  -- cond = function()
  -- end
}
