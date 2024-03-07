-- help: lualine-filetype-component-options
local M = {
  [1] = "filetype",
}

if require("utils").enable_icon then
  M.icon_only = true
end

return M
