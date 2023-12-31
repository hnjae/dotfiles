return function()
  -- local get_mode = require("lualine.utils.mode").get_mode
  -- return get_mode
  return vim.api.nvim_get_mode().mode
end
