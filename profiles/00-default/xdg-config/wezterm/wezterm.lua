local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "_base24"
config.bold_brightens_ansi_colors = "No"
config.audible_bell = "SystemBeep"
config.visual_bell = {
  fade_in_function = "EaseIn",
  fade_in_duration_ms = 80,
  fade_out_function = "EaseOut",
  fade_out_duration_ms = 80,
}
-- make window size to a multiple of the terminal cell size (true) (only works on X11/Wayland/macOS)
config.use_resize_increments = true
config.adjust_window_size_when_changing_font_size = false
config.animation_fps = 60 -- default: 10, visual_bell 에서 사용됨.

require("fonts").apply_to_config(config)
require("tabline").apply_to_config(config)

config.front_end = "WebGpu" -- use Vulkan/Metal/Direct12
config.webgpu_power_preference = "LowPower" -- use integrated gpu if available
config.use_ime = true

config.skip_close_confirmation_for_processes_named = {
  "bash",
  "zsh",
  "fish",
  "tmux",
  "nu",
  "cmd.exe",
  "pwsh.exe",
  "powershell.exe",
}

-- Require wezterm-headless or wezterm on target system
-- wezterm connect <name> 으로 연결
config.ssh_domains = {
  { name = "eris", remote_address = "eris" },
  { name = "osiris", remote_address = "osiris" },
  { name = "isis", remote_address = "isis" },
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
  {
    key = "Enter",
    mods = "CTRL|SHIFT",
    action = act.TogglePaneZoomState,
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
