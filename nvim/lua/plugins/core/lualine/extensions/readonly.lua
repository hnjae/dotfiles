-- for non editable filetypes

-- local ft_names = require("plugins.core.lualine.utils.filetype-names")
--
-- local get_name = function()
--   local filetype = vim.bo.filetype
--
--   if ft_names[filetype] then
--     filetype = ft_names[filetype]
--   end
--
--   return filetype
-- end
--
-- local name
-- if require("utils").use_icons then
--   local get_icon = require("plugins.core.lualine.utils.get-icon")
--   -- name = get_name
--   name = function()
--     local icon = get_icon(nil, vim.bo.filetype)
--     return string.format("%s %s", icon, get_name())
--   end
-- else
--   name = get_name
-- end

local extension = {
  sections = {
    lualine_c = {
      require("plugins.core.lualine.components.filename"),
    },
  },
  inactive_sections = {
    lualine_c = {
      require("plugins.core.lualine.components.filename"),
    },
  },
  filetypes = {
    "tagbar",
    "dbui",
    "dbout",
    "startify",
    "alpha",
    "Outline", -- symbols outline
    "NvimTree",
    "NeogitStatus",
    "NeogitPopUp",
    "OverseerList",
    "noice",
    "checkhealth",
    "qf",
    "TelescopePrompt",
    "sagafinder",
    "sagaoutline",
    -- popup
    "saga_codeaction",
    "sagarename",
    "neo-tree-popup",
    -- "NetrwMessage", -- not a filetype
  },
}

return vim.tbl_deep_extend(
  "keep",
  require("plugins.core.lualine.extensions.basic"),
  extension
)
