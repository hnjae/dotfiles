local devicons = require("nvim-web-devicons")
local icons = {
  -- project = "",
  extension = "",
  project = "P:",
  message = "󰍡",
  git = "",
  symbol = "", -- nf-cod-symbol_field
}

local filename_icons = {
  ["NetrwMessage"] = icons.message,
}

-- 일반적인 filetype 이면 devicons 설정에 추가.
local filetype_icons = {
  netrw = "󰙅", -- nf-md-file_tree
  oil = "󰙅", -- nf-md-file_tree
  NvimTree = "󰙅",
  fugitive = icons.git,
  NeogitStatus = devicons.get_icon("git")[1],
  NeogitPopUp = icons.message,
  help = "󰘥", -- nf-md-help-circle-out-line
  alpha = "󰀫",
  OverseerList = "",
  Noice = icons.message,
  tagbar = "", -- nf-oct-tag
  Outline = icons.symbol,
  Trouble = "", --nf-oct-tools
  TelescopePrompt = "", -- nf-oct-serch
  dbui = devicons.get_icon("db"),
  dbout = devicons.get_icon("db"),
}

local buftype_icons = {
  terminal = devicons.get_icon("sh"),
}

---@param filename? string
---@param filetype? string
---@param buftype? string
---@return string
return function(filename, filetype, buftype)
  if buftype and buftype_icons[buftype] then
    return buftype_icons[buftype]
  end

  if filetype and filetype_icons[filetype] then
    return filetype_icons[filetype]
  end

  if filename and filename_icons[filename] then
    return filename_icons[filename]
  end

  local icon
  icon = devicons.get_icon(filename or filetype, nil)
  if icon then
    return icon
  end

  return "?"
end
