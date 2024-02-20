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

-- for debugging
M.__get_windows = function()
  local window_ids = vim.api.nvim_tabpage_list_wins(0)
  local ret = {}
  for _, winid in pairs(window_ids) do
    local bufid = vim.api.nvim_win_get_buf(winid)
    if bufid == nil then
      goto continue
    end

    if vim.tbl_contains({"notify", "noice"}, vim.api.nvim_buf_get_option(bufid, "filetype")) then
      goto continue
    end

    ret[winid] = {
      bufid = bufid,
      name = vim.api.nvim_buf_get_name(bufid),
      filetype = vim.api.nvim_buf_get_option(bufid, "filetype"),
      buftype = vim.api.nvim_buf_get_option(bufid, "buftype"),
    }
    ::continue::
  end

  vim.notify(vim.inspect(ret))
  return window_ids
end

M.__get_files = function()
  local a =vim.fn.sort(
        vim.fn.globpath(
          vim.fn.stdpath("config"),
          "lua/overseer/template/user/*.lua",
          false,
          true
        )
      )
    require("messages.api").capture_thing(a)
end

return M
