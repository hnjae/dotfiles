-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local package_path = (...)

local path = package_path .. ".setups"
local fpath = string.format("lua/%s/*.lua", string.gsub(path, "%.", "/"))
local paths =
  vim.fn.uniq(vim.fn.sort(vim.fn.globpath(vim.fn.stdpath("config"), fpath, false, true)))

for _, path_ in pairs(paths) do
  require(path .. "." .. path_:match("[^/\\]+$"):sub(1, -5)).setup()
end
