local get_name = function()
  local opts = require("trouble.config").options

  local words = vim.split(opts.mode, "[%W]")
  for i, word in ipairs(words) do
    words[i] = word:sub(1, 1):upper() .. word:sub(2)
  end

  return table.concat(words, " ")
end

local name
if require("utils").enable_icon then
  local icon = require("plugins.ui.lualine.utils.get-icon")(nil, "Trouble")
  name = function()
    return string.format("%s  %s", icon, get_name())
  end
else
  name = get_name
end

local extension = {
  sections = {
    lualine_c = { { name } },
  },
  inactive_sections = {
    lualine_c = { { name } },
  },
  filetypes = { "Trouble" },
}

return vim.tbl_deep_extend(
  "keep",
  require("plugins.ui.lualine.extensions.basic"),
  extension
)
