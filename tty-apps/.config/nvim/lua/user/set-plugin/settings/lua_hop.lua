local M = {}

local status_hop, hop = pcall(require, "hop")

M.setup = function()
  if not status_hop then
    return
  end

  hop.setup { keys = 'etovxqpdygfblzhckisuran' }
end

return M
