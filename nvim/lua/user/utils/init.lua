local M = {}

---@type fun(name: string): string
--- return "" if not found
M.get_color = function(name)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(name)), "fg")
end

local is_root
M.is_root = function()
  if is_root ~= nil then
    return is_root
  end
  is_root = vim.loop.getuid()
  return is_root
end

return M
