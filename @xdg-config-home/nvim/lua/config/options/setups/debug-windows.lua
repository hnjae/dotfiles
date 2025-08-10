-- local description = "debug-windows"

vim.api.nvim_create_user_command("DebugWindows", function()
  local msg = {}
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    local bufid = vim.api.nvim_win_get_buf(winid)
    msg[winid] = {}

    for _, option in ipairs({ "buftype", "filetype" }) do
      msg[winid][option] = vim.api.nvim_get_option_value(option, { buf = bufid })
    end

    for _, x in ipairs({
      "bufname",
      "buflisted",
      "bufwinid",
      "bufwinnr",
      "bufloaded",
      "getbufinfo",
    }) do
      msg[winid][x] = vim.fn[x](bufid)
    end

    msg[winid].zindex = vim.api.nvim_win_get_config(winid).zindex

    msg[winid]["getwininfo"] = vim.fn["getwininfo"](winid)
  end

  print(vim.inspect(msg))
  -- require("messages.api").capture_thing(msg)
end, {})
