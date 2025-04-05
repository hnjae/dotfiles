-- local package_path = (...):match("(.-)[^%.]+$") -- lualine.utils

local is_devicons, devicons = pcall(require, "nvim-web-devicons")
if not is_devicons then
  return function()
    return ""
  end
end

local icons = require("globals").icons

local ft_data = require("state.lualine-ft-data").data

local buftype_icons = {
  -- terminal = devicons.get_icon("terminal"),
  terminal = icons.terminal,
}

---@param filename? string
---@param filetype? string
---@param buftype? string
---@return string?
return function(filename, filetype, buftype)
  if buftype and buftype_icons[buftype] then
    return buftype_icons[buftype]
  end

  if filetype and ft_data[filetype] and ft_data[filetype].icon then
    return ft_data[filetype].icon
  end

  -- icon = devicons.get_icon(filename or filetype, nil, { default = false }) -- name, ext, opts
  --[[
  NOTE: <2025-01-03>
    * filename or devicons.get_icon_name_by_filetype(filetype) or "", 로 filetype 지정 사용.
    * get_icon_name_by_filetype 는 M.get_icon(<modifed-filetype> or "", nil, opts) 를 호출함.
    * `get_icon` 에서 `ext` 를 지정하지 않아도, `filename` 에서 확장자를 추출하여 사용함.
    * `get_icon` 에서 filename 은 full path 이여서는 안된다. (`xsettingsd.conf` 같은 특수 파일명 대응이 안됨.)
    * vim.fn.expand(string.format("#%s:t", tostring(bufnr))) 를 사용할 것.
  ]]
  return devicons.get_icon(
    filename or devicons.get_icon_name_by_filetype(filetype) or "",
    nil,
    { default = false }
  ) -- name, ext, opts
end
