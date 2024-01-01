local M = {}

M.setup = function()
  local paths =
    vim.fn.uniq(vim.fn.sort(vim.fn.globpath(vim.fn.stdpath("config"), "lua/user/builtin/settings/*.lua", false, true)))
  for _, file in pairs(paths) do
    -- vim.cmd("source " .. file)
    require("user.builtin.settings." .. file:match("[^/\\]+$"):sub(1, -5))
  end
end

return M
