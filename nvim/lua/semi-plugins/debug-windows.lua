-- local description = "debug-windows"

local M = {}

M.setup = function()
  vim.api.nvim_create_user_command("DebugWindows", function()
    local msg = {}
    for _, winnr in ipairs(vim.api.nvim_list_wins()) do
      local bufnr = vim.api.nvim_win_get_buf(winnr)
      msg[winnr] = {}

      for _, option in ipairs({ "buftype", "filetype" }) do
        msg[winnr][option] = vim.api.nvim_buf_get_option(bufnr, option)
      end

      for _, x in ipairs({
        "bufname",
        "buflisted",
        "bufwinid",
        "bufwinnr",
        "bufloaded",
        "getbufinfo",
      }) do
        msg[winnr][x] = vim.fn[x](bufnr)
      end

      msg[winnr]["getwininfo"] = vim.fn["getwininfo"](winnr)
    end

    require("messages.api").capture_thing(msg)
  end, {})
end

return M
