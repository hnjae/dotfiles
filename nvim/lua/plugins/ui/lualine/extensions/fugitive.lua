local get_icon = require("plugins.ui.lualine.utils.get-icon")
local icon = get_icon(nil, "fugitive")

local name
if require("utils").enable_icon then
  name = function()
    return string.format("%s %s", icon, vim.fn.FugitiveHead())
  end
else
  name = vim.fn.FugitiveHead
end

local extension = {
  sections = {
    lualine_c = { { name } },
  },
  inactive_sections = {
    lualine_c = { { name } },
  },
  filetypes = { "fugitive" },
}

return vim.tbl_deep_extend(
  "keep",
  require("plugins.ui.lualine.extensions.basic"),
  extension
)
