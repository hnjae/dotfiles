-- NOTE: `theme` 에는 다음 항목이 있어야함. (2023-12-11)
-- * command
-- * visual
-- * replace
-- * insert
-- * normal
-- * inactive
-- * terminal

local M = {}

M.get = function()
  if vim.g.colors_name == nil then
    return "auto"
  end

  local is_theme, theme = pcall(require, "lualine.themes." .. vim.g.colors_name)

  if not is_theme then
    return "auto"
  end

  -- terminal, command 가 없는 theme 이 많다.
  if not theme.terminal then
    theme.terminal = theme.insert
  end
  if not theme.command then
    theme.command = theme.insert
  end

  return theme
end

return M
