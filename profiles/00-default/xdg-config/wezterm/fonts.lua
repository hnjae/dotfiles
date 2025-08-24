-- NOTE: wezterm ignores fontconfig  <2024-11-28>

local wezterm = require("wezterm")

local M = {}
local FONTS = {
  { family = "MesloLGM Nerd Font" },
  {
    family = "Noto Sans Mono CJK JP",
    -- scale = 0.98,
    weight = "Medium",
  },
  {
    family = "Noto Sans Mono CJK KR",
    -- scale = 0.98,
    weight = "Medium",
  },
  { family = "Noto Color Emoji" },
}

M.get_font = function(wezterm)
  return wezterm.font_with_fallback(FONTS)
end

M.apply_to_config = function(opts)
  opts.font = M.get_font(wezterm)
  opts.font_size = 11
  opts.warn_about_missing_glyphs = true
end

return M
