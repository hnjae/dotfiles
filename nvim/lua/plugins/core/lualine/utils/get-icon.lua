local package_path = (...):match("(.-)[^%.]+$") -- lualine.utils

local is_devicons, devicons = pcall(require, "nvim-web-devicons")
if not is_devicons then
  return function()
    return ""
  end
end

local default_icon = require("val").icons.file
local icons = require("val").icons

-- local ft_data = require(package_path .. ".ft-data")
local ft_data = require("state.lualine-ft-data").data

local filename_icons = {
  ["NetrwMessage"] = icons.message,
}

local buftype_icons = {
  terminal = devicons.get_icon("terminal"),
}

---@param filename? string
---@param filetype? string
---@param buftype? string
---@return string
return function(filename, filetype, buftype)
  if buftype and buftype_icons[buftype] then
    return buftype_icons[buftype]
  end

  if filetype and ft_data[filetype] and ft_data[filetype][2] then
    return ft_data[filetype][2]
  end

  if filename and filename_icons[filename] then
    return filename_icons[filename]
  end

  local icon
  icon = devicons.get_icon(filename or filetype, nil, { default = false })
  if icon then
    return icon
  end

  icon = devicons.get_icon_by_filetype(filetype)
  if icon then
    return icon
  end

  return default_icon
end
