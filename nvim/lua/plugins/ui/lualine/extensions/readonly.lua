-- for non editable filetypes

-- local get_icon_by_filetype = require("nvim-web-devicons").get_icon_by_filetype
local icons = require("plugins.ui.lualine.utils").icons

local filetype_names = {
  alpha = "Alpha",
  tagbar = "Tagbar",
  noice = "Noice",
}
local filetype_icons = {
  Alpha = "󰀫 ",
  Noice = icons.message .. " ",
  NvimTree = "󰙅 ",
  NeogitStatus = require("nvim-web-devicons").get_icon("git")[1],
  NeogitPopUp = icons.message .. " ",
  -- startify = "󰕮 ",
  -- dbui = get_icon_by_filetype("db") .. " ",
  -- dbout = get_icon_by_filetype("db") .. " ",
  etc = icons.extension .. " ",
}

local name = {
  [1] = function()
    local filetype = vim.opt_local.filetype:get()
    if filetype_names[filetype] then
      filetype = filetype_names[filetype]
    end

    if filetype_icons[filetype] then
      return filetype_icons[filetype] .. filetype
    end
    return filetype_icons.etc .. filetype
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
    "Outline", -- symbols outline
    "Trouble",
    "NvimTree",
    "NeogitStatus",
    "NeogitPopUp",
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
