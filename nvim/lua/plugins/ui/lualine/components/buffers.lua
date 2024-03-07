-- help: lualine-buffers-component-options
local M = {
  [1] = "buffers",
  mode = 0, -- show buffer name
  buffers_color = {
    active = "BufferCurrent",
    inactive = "BufferInactive",
  },
  symbols = {
    alternate_file = "# ",
  },
  draw_empty = true,
  show_filename_only = true,
  filetype_names = {
    oil = "Oil",
    tagbar = "Tagbar",
    Outline = "Outline",
    NvimTree = "NvimTree",
  },
}

if require("utils").enable_icon then
  local get_icon = require("plugins.ui.lualine.utils.get-icon")

  M.icons_enabled = false
  ---@type fun(name: string, context: object): string
  M.fmt = function(name, context)
    local icon = get_icon(
      vim.fn.expand(string.format("#%s:t", tostring(context.bufnr))),
      context.filetype,
      context.buftype
    )

    if not icon then
      return name
    end

    return string.format("%s %s", icon, name)
  end
end

return M
