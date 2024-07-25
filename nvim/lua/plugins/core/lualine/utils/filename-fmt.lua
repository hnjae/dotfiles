local package_path = (...):match("(.-)[^%.]+$") -- lualine.utils

local utils = require("utils")
local get_icon = require(package_path .. ".get-icon")
-- local ft_data = require(package_path .. ".ft-data")
local ft_data = require("state.lualine-ft-data").data

---@type fun(name: string, context: table): string
return function(name, context)
  local icon = nil

  if ft_data[context.filetype] and ft_data[context.filetype][1] then
    name = ft_data[context.filetype][1]
    if ft_data[context.filetype][2] then
      icon = ft_data[context.filetype][2]
    end
  elseif
    context.filetype ~= ""
    and vim.b[context.bufnr].did_ftplugin ~= nil
    and context.buftype == "nofile"
    -- name == "[No Name]"
  then
    -- e.g. preview pane of LspSaga's outline/hover
    -- name = utils.enable_icon and "󱔘 " or "[DOCUMENT]" -- nf-md-file_document_multiple_outline
    icon = "󱔘"
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
