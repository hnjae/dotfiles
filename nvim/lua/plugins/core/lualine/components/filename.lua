-- -- :h lualine-filename-component-options

local M = {
  [1] = "filename",
  file_status = true,
  newfile_status = true,
  path = 1,
}

---@type fun(filename: string): string
M.fmt = function(filename)
  return require("plugins.core.lualine.utils.filename-fmt")(filename, {
    bufnr = vim.api.nvim_get_current_buf(),
    buftype = vim.bo.buftype,
    filetype = vim.bo.filetype,
  })
end

return M
