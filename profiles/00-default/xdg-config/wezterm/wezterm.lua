local wezterm = require("wezterm")

local config = wezterm.config_builder()
config.bold_brightens_ansi_colors = "No"

require("fonts").apply_to_config(config)
require("ui").apply_to_config(config)

config.webgpu_power_preference = "LowPower"

config.use_ime = true
config.audible_bell = "Disabled"

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

  -- Tab handling (disable creating tab)
  -- {
  --   key = "T",
  --   mods = "CTRL|SHIFT",
  --   action = wezterm.action.Nop,
  -- },

  -- WIP
  -- {
  --   key = "C",
  --   mods = "CTRL",
  --   action = wezterm.action_callback(function(window, pane)
  --     local sel = window:get_selection_text_for_pane(pane) or ""
  --     if #sel > 0 then
  --       wezterm.clipboard.copy_text(sel)
  --       window:perform_action(wezterm.action.ClearSelection, pane)
  --     else
  --       window:perform_action(wezterm.action.SendKey({ key = "C", mods = "CTRL" }), pane)
  --     end
  --   end),
  -- },
}

-- config.send_composed_key_when_left_alt_is_pressed = false
-- config.send_composed_key_when_right_alt_is_pressed = false

return config
