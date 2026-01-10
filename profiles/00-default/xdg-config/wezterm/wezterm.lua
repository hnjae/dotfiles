local wezterm = require("wezterm")

local config = wezterm.config_builder()
config.bold_brightens_ansi_colors = "No"

require("fonts").apply_to_config(config)
require("ui").apply_to_config(config)

config.front_end = "WebGpu" -- use Vulkan/Metal/Direct12
config.webgpu_power_preference = "LowPower" -- use integrated gpu if available

config.use_ime = true
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_function = "EaseIn",
  fade_in_duration_ms = 80,
  fade_out_function = "EaseOut",
  fade_out_duration_ms = 80,
}

-----------------
-- MOUSE Bindings
-----------------

local act = wezterm.action
-- run wezterm show-keys [--lua]
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    -- action = wezterm.action({ SelectTextAtMouseCursor = "Cell" }),
    action = act.CopyTo("PrimarySelection"),
  },
  {
    event = { Up = { streak = 2, button = "Left" } },
    mods = "NONE",
    action = act.CopyTo("PrimarySelection"),
    -- action = wezterm.action({ SelectTextAtMouseCursor = "Cell" }),
  },
  {
    event = { Up = { streak = 3, button = "Left" } },
    mods = "NONE",
    action = act.CopyTo("PrimarySelection"),
    -- action = wezterm.action({ SelectTextAtMouseCursor = "Cell" }),
  },
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = act.OpenLinkAtMouseCursor,
  },
}

-----------------
-- Key Bindings
-----------------
config.keys = {
  {
    key = "Q",
    mods = "CTRL|SHIFT",
    action = wezterm.action.QuitApplication,
  },
  {
    -- claude code newline
    key = "Enter",
    mods = "SHIFT",
    action = wezterm.action({ SendString = "\x1b\r" }),
  },

  -- Pane splitting
  {
    key = "O",
    mods = "CTRL|SHIFT",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "E",
    mods = "CTRL|SHIFT",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },

  -- Pane navigation (vim-style)
  {
    key = "h",
    mods = "ALT",
    action = act.ActivatePaneDirection("Left"),
  },
  {
    key = "l",
    mods = "ALT",
    action = act.ActivatePaneDirection("Right"),
  },
  {
    key = "j",
    mods = "ALT",
    action = act.ActivatePaneDirection("Down"),
  },
  {
    key = "k",
    mods = "ALT",
    action = act.ActivatePaneDirection("Up"),
  },

  -- Pane navigation (arrow keys)
  {
    key = "LeftArrow",
    mods = "ALT",
    action = act.ActivatePaneDirection("Left"),
  },
  {
    key = "RightArrow",
    mods = "ALT",
    action = act.ActivatePaneDirection("Right"),
  },
  {
    key = "DownArrow",
    mods = "ALT",
    action = act.ActivatePaneDirection("Down"),
  },
  {
    key = "UpArrow",
    mods = "ALT",
    action = act.ActivatePaneDirection("Up"),
  },

  -- Tab handling (disable creating tab)
  -- {
  --   key = "T",
  --   mods = "CTRL|SHIFT",
  --   action = wezterm.action.Nop,
  -- },
}

return config
