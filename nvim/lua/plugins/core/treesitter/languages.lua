local M = {}

---@type table <string, boolean>
M._memo = {}

---@type string[]
M._list = {}

---@param ... string
---@return nil
function M:add(...)
  for _, source in ipairs({ ... }) do
    if not M._memo[source] then
      table.insert(M._list, source)
      M._memo[source] = true
    end
  end
end

---@return string[] list of treesitte'r ensure installed source
function M:get_list()
  return M._list
end

return M
