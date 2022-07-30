local M = {}


function M.setup()
  local setting_files = vim.fn.sort(
    vim.fn.globpath(vim.fn.stdpath('config'), 'lua/user/mapping/settings/*.lua', false, true)
  )

  for _, setting in pairs(setting_files) do
    local module_name = "user.mapping.settings." .. setting:match("[^/\\]+$"):sub(1,-5)
    local module = require(module_name)
    module.setup()
  end

  -- for _, module_name in ipairs(module_list) do
  --   local status, module = pcall(require, module_name)
  --   if status then
  --     module.setup()
  --   end
  -- end
end

return M
