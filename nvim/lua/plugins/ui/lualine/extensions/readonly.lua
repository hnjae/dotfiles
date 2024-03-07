-- for non editable filetypes

local filetype_names = {
  alpha = "Alpha",
  tagbar = "Tagbar",
  noice = "Noice",
}

local get_name = function()
  local filetype = vim.bo.filetype

  if filetype_names[filetype] then
    filetype = filetype_names[filetype]
  end

  return filetype
end

local name
if require("utils").enable_icon then
  local get_icon = require("plugins.ui.lualine.utils.get-icon")
  -- name = get_name
  name = function()
    local icon = get_icon(nil, vim.bo.filetype)
    return string.format("%s %s", icon, get_name())
  end
else
  name = get_name
end

local extension = {
  sections = {
    lualine_c = { name },
  },
  inactive_sections = {
    lualine_c = { name },
  },
  filetypes = {
    "tagbar",
    "dbui",
    "dbout",
    "startify",
    "alpha",
    "Outline", -- symbols outline
    "NvimTree",
    "NeogitStatus",
    "NeogitPopUp",
    "OverseerList",
    "noice",
    "checkhealth",
    "qf",
    -- "NetrwMessage", -- not a filetype
  },
}

return vim.tbl_deep_extend(
  "keep",
  require("plugins.ui.lualine.extensions.basic"),
  extension
)
