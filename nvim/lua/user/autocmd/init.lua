local M = {}

function M.setup()
  local paths = vim.fn.uniq(vim.fn.sort(vim.fn.globpath(vim.fn.stdpath("config"), "lua/user/autocmd/setups/*.lua", false, true)))

  for _, file in pairs(paths) do
    require("user.autocmd.setups." .. file:match("[^/\\]+$"):sub(1,-5)).setup()
  end
end

return M
