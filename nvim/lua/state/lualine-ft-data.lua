--[[
왜?
lualine opts 에 건내주고, 추후 활용하는 방법도 생각해보았는데,
component 에서 활용하기가 까다로움.
]]
local M = {}

local icons = require("val").icons

-- 일반적인 filetype 이면 devicons 설정에 추가.

---@class ftData
---@field display_name? string name
---@field icon? string icon
---@alias ft string

---@type table<ft, ftData>
M.data = {
  checkhealth = { display_name = "CheckHealth", icon = "󰗶" }, -- nf-md-heart_pulse
  netrw = { display_name = "Netrw", icon = icons.directory },
  help = { icon = icons.help },

  ------------------------------------------------------------------------------
  -- floating windows
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- sidebar
  ------------------------------------------------------------------------------
  qf = { display_name = "QuickFix", icon = icons.tools },
}
-- dbui = { [2] = "" }, -- nf-oct-database
-- dbout = { [2] = "" }, -- nf-oct-database
-- noice = { "Noice", icons.message },
-- minimap = { [1] = "MINIMAP", [2] = "" }, -- nf-oct-rows
-- NvimTree = { [2] = icons.file_tree },

---@type fun(M: table, data: table<ft, ftData>): nil
function M:add(data)
  for key, val in pairs(data) do
    M.data[key] = val
  end
end

return M
