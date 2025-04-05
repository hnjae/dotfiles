local package_path = (...):match("(.-)[^%.]+$") -- lualine.utils

local utils = require("utils")
local get_icon = require(package_path .. ".get-icon")
local ft_data = require("plugins.core.lualine.utils.buffer-attributes").data

---@type fun(name: string, context: table): string
return function(name, context)
  ---@type string?
  local icon = nil

  if ft_data[context.filetype] then
    name = ft_data[context.filetype].display_name or name
    icon = ft_data[context.filetype].icon or icon
  elseif context.buftype == "nofile" then
    -- and vim.b[context.bufnr].did_ftplugin ~= nil
    -- and context.buftype == "nofile"
    return name
  elseif
    context.filetype == ""
    and context.file == ""
    and context.buftype == ""
  then
    return name
  end

  if not icon then
    icon = get_icon(
      vim.fn.expand(string.format("#%s:t", tostring(context.bufnr))),
      context.filetype,
      context.buftype
    )
  end

  if not icon or not utils.enable_icon then
    return name
  end

  return string.format("%s %s", icon, name)
end
