---@type LspSpec
local M = {}

M.get_conform_opts = function()
  return {
    formatters_by_ft = {
      xml = { { "tidy" } },
    },
  }
end

return M
