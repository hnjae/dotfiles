local M = {}
local wezterm = require("wezterm")

M.apply_to_config = function(config)
  config.color_scheme = "_base24"

  -- local config_home = os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config"
  -- local scheme = wezterm.color.load_scheme(config_home .. "/wezterm/colors/_base24.toml")
  -- print(config.colors)

  config.visual_bell = {
    fade_in_function = "EaseIn",
    fade_in_duration_ms = 80,
    fade_out_function = "EaseOut",
    fade_out_duration_ms = 80,
  }

  config.window_padding = {
    left = "0.5cell",
    right = "0.5cell",
    top = "0.25cell",
    bottom = "0.25cell",
  }
  -- make window size to a multiple of the terminal cell size (true) (only works on X11/Wayland/macOS)
  config.use_resize_increments = false

  -- NOTE: also used in fancy_tab_bar
  config.window_frame = {
    font_size = 11.6,
    active_titlebar_bg = "#292c30", -- breeze-dark
  }

  ------------
  -- TAB BAR
  ------------
  -- config.hide_tab_bar_if_only_one_tab = false
  -- config.use_fancy_tab_bar = false
  --
  -- config.colors = config.colors or {}
  -- config.colors.tab_bar = {
  --   --     background = scheme.background,
  --   --
  --   active_tab = {
  --     bg_color = scheme.selection_bg,
  --     fg_color = scheme.foreground,
  --     intensitDefault Foreground, Caret, Delimiters, Operatorsy = "Bold",
  --   },
  -- }
end

return M
