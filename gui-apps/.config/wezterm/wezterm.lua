-- https://wezfurlong.org/wezterm/config/lua/config/use_ime.html

local wezterm = require('wezterm')
local is_linux = os.getenv("XDG_SESSION_TYPE") ~= nil

local ret = {
  font = wezterm.font_with_fallback(
    { family = 'Monospace' }
    -- {
    --   family = 'MesloLGS Nerd Font Mono',
    --   harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
    -- },
  ),
  -- color_scheme = 'Vacuous 2 (terminal.sexy)', -- 블랙 글자가 잘 안보임
  -- color_scheme = 'Classic Dark (base16)', -- Input Box안의 글자가 안보임.
  color_scheme = 'Github Dark',
  warn_about_missing_glyphs = false,
  use_ime = true,
}




if is_linux then
  -- ret["window_decorations"] = "NONE"
  ret["use_resize_increments"] = true
else
  -- ret["window_decorations"] = "TITLE | RESIZE" -- defaults
  ret["use_resize_increments"] = false -- defaults
end

return ret
