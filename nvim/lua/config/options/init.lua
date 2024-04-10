local M = {}

local package_path = (...)

M.setup = function()
  for _, package in
    ipairs(require("utils").get_packages(package_path .. ".settings"))
  do
  end
end

return M
