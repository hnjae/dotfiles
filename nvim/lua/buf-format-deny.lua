local M = {}

---@type { string: boolean }
M.list = {}

---@type function(source: string)
---@param source string lsp or null-ls source that has formatter
function M:add(source)
  M.list[source] = true
end

return M
