local M = {}

-- vim.fn.globpath(vim.o.runtimepath, 'lua/set-plugin/*.lua', false, true)
M.setup = function()

  local paths = vim.fn.uniq(
    vim.fn.sort(
      vim.fn.globpath(vim.fn.stdpath('config'), 'lua/user/set-plugin/legacy/*.lua', false, true)
    )
  )
  for _, file in pairs(paths) do
    vim.cmd('source ' .. file)
  end


  local setting_files = vim.fn.sort(
    vim.fn.globpath(vim.fn.stdpath('config'), 'lua/user/set-plugin/settings/*.lua', false, true)
  )

  for _, setting in pairs(setting_files) do
    local module_name = "user.set-plugin.settings." .. setting:match("[^/\\]+$"):sub(1,-5)
    local module = require(module_name)
    module.setup()
  end

end

return M
