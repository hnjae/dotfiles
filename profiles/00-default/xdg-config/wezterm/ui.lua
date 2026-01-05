local M = {}
local wezterm = require("wezterm")

M.apply_to_config = function(config)
  config.color_scheme = "_base24"
  -- or
  -- local config_home = os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config"
  -- config.colors = wezterm.color.load_scheme(config_home .. "/wezterm/colors/_base24.toml")

  config.window_padding = {
    left = "0.5cell",
    right = "0.5cell",
    top = "0.25cell",
    bottom = "0.25cell",
  }

  -- NOTE: also used in fancy_tab_bar
  config.window_frame = {
    font_size = 11.5,
    active_titlebar_bg = "#292c30", -- breeze-dark
  }

  ------------
  -- TAB BAR
  ------------
  config.hide_tab_bar_if_only_one_tab = false
  config.tab_bar_at_bottom = false
  config.use_fancy_tab_bar = true

  -- init attributes
  config.window_frame = config.window_frame or {}
  config.colors = config.colors or {}

  -- Get colors from the configured color scheme
  -- if scheme ~= nil then
  --   -- Tab bar colors using color scheme palette
  --
  --   config.colors.tab_bar = {
  --     background = scheme.background,
  --
  --     active_tab = {
  --       bg_color = scheme.background,
  --       fg_color = scheme.foreground,
  --       intensity = "Bold",
  --     },
  --
  --     inactive_tab = {
  --       bg_color = config.window_frame.active_titlebar_bg,
  --       -- bg_color = scheme.brights[1], -- bright black
  --       fg_color = scheme.brights[8], -- bright white (dimmed)
  --     },
  --
  --     inactive_tab_hover = {
  --       bg_color = scheme.brights[2], -- bright red (or another accent)
  --       fg_color = scheme.foreground,
  --     },
  --
  --     new_tab = {
  --       bg_color = config.window_frame.active_titlebar_bg,
  --       fg_color = scheme.brights[8],
  --     },
  --     new_tab_hover = {
  --       bg_color = "#223249",
  --       fg_color = scheme.brights[8],
  --     },
  --   }
  -- end

  -- make window size to a multiple of the terminal cell size (true)
  -- only works on X11/Wayland/macOS
  config.use_resize_increments = false
  -- opts.window_frame = {
  --   font = require("fonts").get_font(wezterm),
  --   font_size = 11,
  -- }
end

return M
