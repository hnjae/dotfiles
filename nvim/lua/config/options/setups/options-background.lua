local COLORFGBG = os.getenv("COLORFGBG")
if COLORFGBG == "15;0" then
  vim.opt.background = "dark"
elseif COLORFGBG == "0;15" then
  vim.opt.background = "light"
else
  vim.opt.background = "dark"
  -- vim.opt.background = "light"
end
