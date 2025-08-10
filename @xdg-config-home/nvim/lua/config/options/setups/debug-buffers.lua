-- local description = "debug-buffers"

vim.api.nvim_create_user_command("DebugBuffers", function()
  local msg = {}
  for _, bufid in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.tbl_contains({
        "noice",
        "cmp_menu",
        "cmp_docs",
      }, vim.api.nvim_get_option_value("filetype", { buf = bufid }))
    then
      goto continue
    end

    msg[bufid] = {}

    for _, option in ipairs({
      "buftype",
      "buflisted",
      "filetype",
    }) do
      msg[bufid][option] = vim.api.nvim_get_option_value(option, { buf = bufid })
    end

    for _, x in ipairs({
      "bufname",
      "bufwinid",
      "bufwinnr",
      "bufloaded",
      "getbufinfo",
    }) do
      msg[bufid][x] = vim.fn[x](bufid)
    end

    ::continue::
  end

  -- require("messages.api").capture_thing(msg)
  print(vim.inspect(msg))
end, {})
