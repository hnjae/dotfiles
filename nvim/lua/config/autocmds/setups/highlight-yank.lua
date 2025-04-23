local M = {}

M.setup = function()
  local yank_auto_id = vim.api.nvim_create_augroup("yank", {})

  vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    group = yank_auto_id,
    pattern = { "*" },
    callback = function()
      vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })
    end,
  })
end

return M
