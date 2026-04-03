local M = {}

function M.setup()
  vim.api.nvim_create_autocmd({
    "FileType",
  }, {
    pattern = { "man" },
    callback = function()
      vim.opt_local.ruler = true
      vim.opt_local.number = true
      vim.opt_local.relativenumber = true
    end,
  })
end

return M
