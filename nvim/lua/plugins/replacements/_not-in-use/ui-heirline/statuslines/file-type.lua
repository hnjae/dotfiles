return function(modules)
  local FileType = {
    provider = function()
      return string.upper(vim.bo.filetype)
    end,
    hl = { fg = modules.utils.get_highlight("Type").fg, bold = true },
  }

  return FileType
end
