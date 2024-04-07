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

-- local is_treesitter = vim.fn.executable("cc") == 1
M.is_treesitter = function()
  if is_treesitter ~= nil then
    return is_treesitter
  end

  is_treesitter = vim.fn.executable("cc") == 1
  return is_treesitter
end

M.is_console = os.getenv("XDG_SESSION_TYPE") == "tty"

M.enable_icon = not (os.getenv("XDG_SESSION_TYPE") == "tty" and os.getenv("SSH_TTY") == nil)

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

M._plugins = nil
M._plugin_memo = {}
---@type fun(name: string): boolean
M.is_plugin = function(name)
  if M._plugin_memo[name] ~= nil then
    return M._plugin_memo[name]
  end

  if not M._plugins then
    M._plugins = require("lazy.core.config").plugins
  end

  local plugin = M._plugins[name]
  M._plugin_memo[name] = (plugin ~= nil and (plugin.enabled == nil or plugin.enabled) and (plugin.cond == nil or plugin.cond))
  -- vim.notify(vim.inspect( {
  --   plugin = plugin ~= nil,
  --   enabled = plugin ~= nil and (plugin.enabled == nil or plugin.enabled),
  --   cond = plugin ~= nil and (plugin.cond == nil or plugin.cond),
  --   plugins = M._plugins
  -- } ), {timeout=false})
  return M._plugin_memo[name]
end

---@return string browser -- e.g.) firefox --
M._browser_memo = nil
M.get_browser_cmd = function()
  if M._browser_memo then
    return M._browser_memo
  end

  local browser = os.getenv("BROWSER")
  if browser == nil then
    if vim.fn.executable("firefox") == 1 then
      browser = "firefox --"
    elseif vim.fn.executable("chromium") then
      browser = "chromium --"
    end
    -- if vim.fn.has("linux") and vim.fn.executable("flatpak") then
    --   browser = "flatpak run org.mozilla.firefox --"
  end

  if not browser then
    browser = "xdg-open"
  end

  M._browser_memo = browser

  return M._browser_memo
end

return M
