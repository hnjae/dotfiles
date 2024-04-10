local M = {}
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
  M._plugin_memo[name] = (
    plugin ~= nil
    and (plugin.enabled == nil or plugin.enabled)
    and (plugin.cond == nil or plugin.cond)
  )
  -- vim.notify(vim.inspect( {
  --   plugin = plugin ~= nil,
  --   enabled = plugin ~= nil and (plugin.enabled == nil or plugin.enabled),
  --   cond = plugin ~= nil and (plugin.cond == nil or plugin.cond),
  --   plugins = M._plugins
  -- } ), {timeout=false})
  return M._plugin_memo[name]
end

return M.is_plugin
