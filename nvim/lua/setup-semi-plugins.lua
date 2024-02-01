local M = {}

M.setup = function()
  local paths = vim.fn.uniq(
    vim.fn.sort(
      vim.fn.globpath(
        vim.fn.stdpath("config"),
        "lua/semi-plugins/*.lua",
        false,
        true
      )
    )
  )
  for _, file in pairs(paths) do
    require("semi-plugins/" .. file:match("[^/\\]+$"):sub(1, -5)).setup()
  end
end

return M
