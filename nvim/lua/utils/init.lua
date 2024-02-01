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
  is_root = vim.loop.getuid() == 0
  return is_root
end

M.is_console = os.getenv("XDG_SESSION_TYPE") == "tty"

local xdg_cache = {}
M.get_xdg_path = function(type)
  if xdg_cache[type] ~= nil then
    return xdg_cache[type]
  end

  if type == "state" then
    xdg_cache[type] = os.getenv("XDG_STATE_HOME")
      or os.getenv("HOME") .. "/.local/state"
    return xdg_cache[type]
  end

  return ""
end

return M
