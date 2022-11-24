local M = {}

M.setup = function()
  local group_id = vim.api.nvim_create_augroup("mac_ime", {})
  vim.api.nvim_create_autocmd(
    {"InsertLeave"},
    {
      group = group_id,
      pattern = {"*"},
      callback = function()
        -- send F19 to system
        vim.fn.jobstart({
          "osascript", "-e", 'tell application \"System Events\" to key code 80'
        })
        -- os.execute("osascript -e 'tell application \"System Events\" to key code 80'")
      end
    }
  )

  vim.api.nvim_create_autocmd(
    {"InsertEnter"},
    {
      group = group_id,
      pattern = {"*"},
      callback = function()
        -- send F20 to system
        vim.fn.jobstart({
          "osascript", "-e", 'tell application \"System Events\" to key code 90'
        })
        -- os.execute("osascript -e 'tell application \"System Events\" to key code 90'")
      end
    }
  )
end

return M
