local get_icon_by_filetype = require("nvim-web-devicons").get_icon_by_filetype
local get_icon = require("nvim-web-devicons").get_icon

local filename_icons = {
  ["NetrwMessage"] = require("plugins.ui.lualine.utils").icons.message,
}

return {
  [1] = "filename",
  ---@type fun(filename: string): string
  fmt = function(filename)
    local raw_filename = vim.fn.expand("%")

    if require("utils").is_console then
      return filename
    end

    local icon = filename_icons[raw_filename] and filename_icons[raw_filename]
      or get_icon(raw_filename)

    if not icon then
      icon = get_icon_by_filetype(vim.bo.filetype)
    end

    if not icon then
      if vim.bo.filetype == "" then
        icon = ""
      else
        icon = get_icon_by_filetype("txt")
      end
    end

    return icon .. " " .. filename
  end,
}
