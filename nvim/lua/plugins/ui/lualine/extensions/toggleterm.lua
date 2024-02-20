local name = function()
  local tterm_msg = "#" .. vim.b.toggle_number

  local bname = vim.api.nvim_buf_get_name(0)
  local match = string.match(vim.split(bname, " ")[1], "term:.*:(%a+)")
  local fname = match ~= nil and match
    or vim.fn.fnamemodify(vim.env.SHELL, ":t")

  local icon = require("nvim-web-devicons").get_icon(fname)
  if icon == nil then
    icon = require("nvim-web-devicons").get_icon("sh")
  end

  return string.format("%s %s %s", tterm_msg, icon, fname)
end

local extension = {
  sections = {
    lualine_c = { name },
  },
  inactive_sections = {
    lualine_c = { name },
  },
  filetypes = {
    "toggleterm",
  },
}

local ext = vim.tbl_deep_extend(
  "keep",
  require("plugins.ui.lualine.extensions.basic"),
  extension
)

return ext
