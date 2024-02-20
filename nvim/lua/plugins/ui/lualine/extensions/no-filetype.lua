local name = function()
  local bname = vim.api.nvim_buf_get_name(0)

  if vim.bo.buftype("terminal") and not require("utils").is_console then
    local icon = require("nvim-web-devicons").get_icon("sh")
    return string.format("%s %s", icon, bname)
  end

  return bname
end

local extension = {
  sections = {
    lualine_c = { name },
  },
  inactive_sections = {
    lualine_c = { name },
  },
  filetypes = {
    "",
  },
  -- buftypes = {
  --   "terminal",
  -- },
}

local ext = vim.tbl_deep_extend(
  "keep",
  require("plugins.ui.lualine.extensions.basic"),
  extension
)

return ext
