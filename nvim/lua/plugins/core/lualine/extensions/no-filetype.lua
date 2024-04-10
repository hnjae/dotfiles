local name
if require("utils").enable_icon then
  name = function()
    local bname = vim.api.nvim_buf_get_name(0)

    local icon = nil
    if vim.bo.buftype == "terminal" then
      icon = require("nvim-web-devicons").get_icon("sh")
    end

    if not icon then
      return bname
    end

    return string.format("%s %s", icon, bname)
  end
else
  name = function()
    return vim.api.nvim_buf_get_name(0)
  end
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
  require("plugins.core.lualine.extensions.basic"),
  extension
)

return ext
