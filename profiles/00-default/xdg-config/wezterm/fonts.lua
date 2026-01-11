local wezterm = require("wezterm")

local cjkscale = 1.16

local M = {}
local FONTS = {
  { family = "MesloLGL Nerd Font" },
  { family = "Pretendard JP", scale = cjkscale },
  { family = "Noto Color Emoji" },
  { family = "Jigmo", scale = cjkscale },
  { family = "Jigmo2", scale = cjkscale },
  { family = "Jigmo3", scale = cjkscale },
}

M.apply_to_config = function(config)
  -- config.line_height = 1.2
  config.font = wezterm.font_with_fallback(FONTS)
  config.font_size = 11
  config.warn_about_missing_glyphs = false
end

return M
