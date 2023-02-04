local M = {}

M.setup = function()
  local paths =
    vim.fn.uniq(vim.fn.sort(vim.fn.globpath(vim.fn.stdpath("config"), "lua/user/builtin/settings/*.lua", false, true)))
  for _, file in pairs(paths) do
    vim.cmd("source " .. file)
  end

  -- for _, setting in pairs(paths) do
  --   local module_name = "user.mapping.settings." .. setting:match("[^/\\]+$"):sub(1,-5)
  --   local module = require(module_name)
  --   module.setup()
  -- end
end

return M
