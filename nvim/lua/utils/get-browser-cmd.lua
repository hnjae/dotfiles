local M = {}

M._browser_memo = nil
---@return string browser -- e.g.) firefox --
M.get_browser_cmd = function()
  if M._browser_memo then
    return M._browser_memo
  end

  -- xdg-settings get default-web-browser
  local browser = os.getenv("BROWSER")
  if browser == nil then
    if vim.fn.executable("firefox") == 1 then
      browser = "firefox --"
    elseif vim.fn.executable("chromium") then
      browser = "chromium --"
    end
    -- if vim.fn.has("linux") and vim.fn.executable("flatpak") then
    --   browser = "flatpak run org.mozilla.firefox --"
  end

  if not browser then
    browser = "xdg-open"
  end

  M._browser_memo = browser

  return M._browser_memo
end

return M.get_browser_cmd
