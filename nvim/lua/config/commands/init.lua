local M = {}

local package_path = (...)

M.setup = function()
  for _, package in
    ipairs(require("utils").get_packages(package_path .. ".setups"))
  do
    package.setup()
  end
end

return M
