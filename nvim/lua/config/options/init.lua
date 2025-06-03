-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local package_path = (...)

local path = package_path .. ".setups"
local fpath = string.format("lua/%s/*.lua", string.gsub(path, "%.", "/"))
local paths =
  vim.fn.uniq(vim.fn.sort(vim.fn.globpath(vim.fn.stdpath("config"), fpath, false, true)))

if type(paths) == "table" then
  for _, path_ in pairs(paths) do
    require(path .. "." .. path_:match("[^/\\]+$"):sub(1, -5))
  end
end

function _G.pp(...)
  local objects = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  vim.notify(table.concat(objects, "\n"))
  return ...
end

------------------------------------------------------------------------------

-- local package_path = (...)
-- local path = package_path .. ".setups"
-- local dir_path = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", string.gsub(path, "%.", "/"))
--
-- local paths = vim.fs.find(function(name)
--   return name:match("%.lua$")
-- end, { path = dir_path, type = "file" })
--
-- table.sort(paths)
--
-- for _, file_path in ipairs(paths) do
--   print(file_path)
--   local module_name = vim.fs.basename(file_path):sub(1, -5)
--   require(path .. "." .. module_name)
-- end
