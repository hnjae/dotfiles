-- LSP 중에 formatter 로 사용하지 않을 것을 저장
local M = {}

---@type table <string, boolean>
M.list = {}

---@type function
---@param source string lsp or null-ls source that has formatter
function M:add(source)
  M.list[source] = true
end

return M
