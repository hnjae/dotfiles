local COLORFGBG = os.getenv("COLORFGBG")
if COLORFGBG == "15;0" then
  vim.opt.background = "dark"
elseif COLORFGBG ~= nil then
  vim.opt.background = "light"
end
