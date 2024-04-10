-- https://github.com/LuaLS/lua-language-server/wiki/Annotations

---@meta

---@class myLualineOpts
---@field options table
---@field sections myLualineSection
---@field inactive_sections myLualineSection
---@field tabline myLualineSection
---@field winbar table
---@field inactive_winbar table
---@field extensions table

---@class myLualineSection
---@field lualine_a? myLualineLocation
---@field lualine_b? myLualineLocation
---@field lualine_c? myLualineLocation
---@field lualine_x? myLualineLocation
---@field lualine_y? myLualineLocation
---@field lualine_z? myLualineLocation

---@alias myLualineLocation (myLualineComponent|LualineComponent)[]

---@class myLualineComponent
---@field priority number
---@field component LualineComponent

---@class LualineComponent: table,string
