local COLORFGBG = os.getenv("COLORFGBG")
if COLORFGBG == "15;0" then
  vim.opt.background = "dark"
-- elseif COLORFGBG == "0;15" then
else
  vim.opt.background = "light"
end
