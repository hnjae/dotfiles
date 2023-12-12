-- NOTE: `theme` 에는 다음 항목이 있어야함. (2023-12-11)
-- * command
-- * visual
-- * replace
-- * insert
-- * normal
-- * inactive
-- * terminal
--

if vim.g.colors_name == nil then
  return "auto"
end

local is_theme, theme = pcall(require, "lualine.themes." .. vim.g.colors_name)
if vim.g.colors_name == "vscode" and vim.opt_local.background:get() == "dark" then
  -- NOTE: vscode's lualine theme sucks
  is_theme = true
  theme = require("lualine.themes.codedark")
end

if is_theme then
  -- terminal, command 가 없는 theme 이 많다.
  if not theme.terminal then
    theme.terminal = theme.insert
  end
  if not theme.command then
    theme.command = theme.insert
  end
else
  theme = "auto"
end

return theme
