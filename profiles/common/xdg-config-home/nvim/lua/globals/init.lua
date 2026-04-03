--[[
  README:
    - 설정 전역에 필요한 data 를 모아둡니다.
]]
local package_path = (...)

local M = {}

M.root_patterns = require(package_path .. ".root-patterns")
M.icons = require(package_path .. ".icons")

return M
