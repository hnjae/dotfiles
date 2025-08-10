local M = {}

local FILETYPES = {
  aerial = true,
  minimap = true,
  ["copilot-chat"] = true,
}

M.setup = function()
  vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(ev)
      -- NOTE:
      -- ev.buf: 닫힌 윈도우의 버퍼

      if vim.api.nvim_get_option_value("buftype", { buf = ev.buf }) ~= "" then
        return
      end

      -- HACK: 커서가 다른 윈도우에 포커스 되었다고 가정하기 위해 대기 <2025-04-22>
      vim.defer_fn(function()
        local buf = vim.api.nvim_get_current_buf()
        -- vim.notify(vim.api.nvim_get_option_value("filetype", { buf = buf }))
        if not FILETYPES[vim.api.nvim_get_option_value("filetype", { buf = buf })] then
          return
        end

        vim.cmd("quit")

        -- 아래 두개로 제거하면 안됨
        -- require("snacks").bufdelete(buf)
        -- require("aerial").close()
      end, 5)
    end,
  })
end

return M
