local is_telescope, telescope = pcall(require, "telescope")
local is_lspconfig, lspconfig = pcall(require, "lspconfig")
local val = require("val")
local M = {}

if not is_telescope or not is_lspconfig then
  local msg = "Both Telescope and lspconfig should be installed."
  vim.notify(msg, vim.log.levels.WARN)
  return M
end

local find_root = lspconfig.util.root_pattern(unpack(val.root_patterns))

M.find_files = function()
  telescope.find_files({cwd = find_root(vim.fn.expand('%:p:h'))})
end

-- aaa = (vim.fn.expand("%:p:h"))
-- vim.notify(aaa)

-- root_dir = lspconfig.util.root_pattern(val.root_patterns)
-- vim.notify(root_dir)
end
