--[[
  어떤 이유인지 모르겠지만, ftplugin 에서 선언하면 작동하지 않는 것들어 여기에 둠.
]]

local M = {}

function M.setup()
  require('user.lsp').setup({"bashls", "sumneko_lua"})
end

return M
