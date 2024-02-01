local modules = require("lualine_require").lazy_require({
  noice = "noice",
})

local get_color = function()
  local utils = require("utils")
  local highlights = {
    "GitSignsChange",
    "WarningMsg",
  }

  local color
  for _, highlight in pairs(highlights) do
    color = utils.get_color(highlight)
    if color ~= "" then
      return color
    end
  end

  return "#ff9e64"
end

return {
  [1] = modules.noice.api.status.search.get,
  cond = modules.noice.api.status.search.has,
  color = { fg = get_color() },
}
