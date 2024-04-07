local M = {
  [1] = "filename",
  file_status = true,
  newfile_status = true,
  -- cond = function()
  --   if
  --     vim.bo.buftype == "nofile"
  --     and vim.bo.filetype ~= ""
  --     and vim.b[0].did_ftplugin ~= nil
  --   then
  --     -- e.g. preview pane of LspSaga's outline/hover
  --     return false
  --   end
  --
  --   return true
  -- end,
}

---@type fun(filename: string): string
M.fmt = function(filename)
  -- if ft_names[vim.bo.filetype] then
  --   filename = ft_names[vim.bo.filetype]
  -- end

  -- return "hi"
  return require("plugins.ui.lualine.utils.filename-fmt")(filename, {
    bufnr = vim.api.nvim_get_current_buf(),
    buftype = vim.bo.buftype,
    filetype = vim.bo.filetype,
  })
end

return M
