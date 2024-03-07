local get_icon = require("plugins.ui.lualine.utils.get-icon")

local name = function()
  local tterm_msg = "#" .. vim.api.nvim_buf_get_var(0, "toggle_number")

  local bname = vim.api.nvim_buf_get_name(0)
  local match = string.match(vim.split(bname, " ")[1], "term:.*:(%a+)")
  local fname = match ~= nil and match
    or vim.fn.fnamemodify(vim.env.SHELL, ":t")

  if not require("utils").enable_icon then
    return string.format("%s %s", tterm_msg, fname)
  end

  -- return string.format("%s %s %s", tterm_msg, get_icon(fname), fname)
  return string.format(
    "%s %s %s",
    tterm_msg,
    get_icon(nil, nil, vim.bo.buftype),
    fname
  )
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
