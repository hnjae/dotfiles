-- local description = "debug-windows"

local M = {}

M.setup = function()
  vim.api.nvim_create_user_command("DebugBuffers", function()
    local msg = {}
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      msg[bufnr] = {}

      for _, option in ipairs({ "buftype", "filetype" }) do
        msg[bufnr][option] = vim.api.nvim_buf_get_option(bufnr, option)
      end

      for _, x in ipairs({
        "bufname",
        "buflisted",
        "bufwinid",
        "bufwinnr",
        "bufloaded",
        "getbufinfo",
      }) do
        msg[bufnr][x] = vim.fn[x](bufnr)
      end
    end

    require("messages.api").capture_thing(msg)
  end, {})
end

return M
