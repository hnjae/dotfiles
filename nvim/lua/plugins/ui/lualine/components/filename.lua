local M = {
  [1] = "filename",
}

if require("utils").enable_icon then
  local get_icon = require("plugins.ui.lualine.utils.get-icon")

  ---@type fun(filename: string): string
  M.fmt = function(filename)
    local icon = get_icon(vim.fn.expand("%:t"), vim.bo.filetype)
    if not icon then
      return filename
    end
    return string.format("%s %s", icon, filename)
  end
end

return M
