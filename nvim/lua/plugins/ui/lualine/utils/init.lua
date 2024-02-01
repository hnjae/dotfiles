local M = {}

-- https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets
-- Based on above code (2024-01-01)
-- This code does not follow license of my projects.

--- @param trunc_width number|nil truncates component when screen width is less then trunc_width
--- @param trunc_len number|nil truncates component to trunc_len number of chars
--- @param hide_width number|nil hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
M.trunc = function(trunc_width, trunc_len, hide_width, max_len, no_ellipsis)
  return function(str)
    local win_width = vim.fn.winwidth(0)
    if hide_width and win_width < hide_width then
      return ""
    elseif
      trunc_width
      and trunc_len
      and win_width < trunc_width
      and #str > trunc_len
    then
      -- "" 을 리턴할 경우, luasnip 에서 아이콘을 출력지 않음.
      if trunc_len <= 0 then
        return "⋯"
      end
      return str:sub(1, trunc_len) .. (no_ellipsis and "" or "⋯")
    elseif max_len and string.len(str) > max_len then
      return str:sub(1, max_len - 1) .. "⋯"
    end
    return str
  end
end

M.icons = {
  extension = "",
  -- project = "",
  project = "P:",
  message = "󰍡",
  git = "",
  git_branch = "",
}

return M
