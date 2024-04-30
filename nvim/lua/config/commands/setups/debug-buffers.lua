-- local description = "debug-windows"

local M = {}

M.setup = function()
  vim.api.nvim_create_user_command("DebugBuffers", function()
    local msg = {}
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if
        vim.tbl_contains({
          "noice",
          "cmp_menu",
          "cmp_docs",
        }, vim.api.nvim_buf_get_option(bufnr, "filetype"))
      then
        goto continue
      end

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

      ::continue::
    end

    require("messages.api").capture_thing(msg)
  end, {})
end

return M
