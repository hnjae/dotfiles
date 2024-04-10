---@diagnostic disable: param-type-mismatch

---@param path string e.g. "config.autocmds.setup."
---@return object[]
return function(path)
  local ret = {}
  local fpath = string.format("lua/%s/*.lua", string.gsub(path, "%.", "/"))
  -- -- local fpath = "lua/config/semi-plugins/plugins/*.lua"
  -- local fpath = "lua/overseer/template/user/*.lua"
  -- local fpath = "lua/plugins/lsp/configs/*.lua"
  local paths = vim.fn.uniq(
    vim.fn.sort(vim.fn.globpath(vim.fn.stdpath("config"), fpath, false, true))
  )

  for _, file in pairs(paths) do
    table.insert(ret, require(path .. "." .. file:match("[^/\\]+$"):sub(1, -5)))
  end

  return ret
end
