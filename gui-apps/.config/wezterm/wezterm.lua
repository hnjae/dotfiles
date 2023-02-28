-- https://wezfurlong.org/wezterm/config/lua/config/use_ime.html

local wezterm = require("wezterm")
local xdg_config_home = nil
if os.getenv("XDG_CONFIG_HOME") ~= nil then
  xdg_config_home = os.getenv("XDG_CONFIG_HOME")
else
  xdg_config_home = os.getenv("HOME") .. "/.config"
end

local opt = {
  font = wezterm.font_with_fallback({
    -- { family = "Prentendard" },
    {
      family = "MesloLGS Nerd Font Mono",
    },
    { family = "Noto Sans Mono CJK JP" },
    { family = "Noto Sans Mono CJK KR" },
    -- NOTE: wezterm does not follows fontconfig's fallback font for unknown reason
    { family = "Monospace" },
  }),
  -- color_scheme = 'Vacuous 2 (terminal.sexy)', -- 블랙 글자가 잘 안보임
  -- color_scheme = 'Classic Dark (base16)', -- Input Box안의 글자가 안보임.
  -- color_scheme = "Github Dark",
  -- color_scheme = "Vacuous 2 (terminal.sexy)",
  -- color_scheme = "SeaShells",
  color_scheme_dirs = { xdg_config_home .. "/wezterm/colors" },
  color_scheme = "codedark",

  warn_about_missing_glyphs = true,
  use_ime = true,

  -- UI
  use_fancy_tab_bar = true,
  window_frame = {
    font = wezterm.font_with_fallback({
      { family = "Prentendard" },
      { family = "sans-serif" },
    }),
    font_size = 11,
    -- active_titlebar_bg = "#111111",
  },
  window_padding = {
    -- left = "10px",
    left = "0.5cell",
    right = "0.5cell",
    top = 0,
    bottom = 0,
  },
  -- make window size to a multiple of the terminal cell size
  -- only works on X11/Wayland/macOS
  use_resize_increments = true,
}

return opt
