-- for non editable filetypes

local filetype_names = {
  alpha = "Alpha",
  tagbar = "Tagbar",
}

local name = {
  [1] = function()
    local filetype = vim.opt_local.filetype:get()
    if filetype_names[filetype] then
      return filetype_names[filetype]
    end

    return filetype
  end,
}

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
    "Outline",
    "Trouble",
  },
}

return vim.tbl_deep_extend(
  "keep",
  require("plugins.ui.lualine.extensions.basic"),
  extension
)
