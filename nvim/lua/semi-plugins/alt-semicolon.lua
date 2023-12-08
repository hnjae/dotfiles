local description = "insert a semicolon after $"

local M = {}

M.setup = function()
  vim.keymap.set("i", "<A-;>", function()
    local line_len = vim.fn.getline("."):len()
    local cursor_loc = vim.api.nvim_win_get_cursor(0)

    -- use lua API instead of vim.fn.execute("normal! A;")
    vim.api.nvim_buf_set_text(0, cursor_loc[1] - 1, line_len, cursor_loc[1] - 1, line_len, { ";" })
    -- if the cursor had been at $+1
    if line_len == cursor_loc[2] then
      vim.api.nvim_win_set_cursor(0, { cursor_loc[1], line_len + 1 })
    end
  end, { desc = description })
end

return M
