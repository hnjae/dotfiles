if (( ! $+commands[starship] )) || [[ "$TERM" == "dumb" ]]; then
  return
fi

local starship_conf="${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
local initfile="${0:A:h}/_starship.zsh"

# NOTE: binary in nix/NixOS always unixtime=0 <2025-06-17>
# if [[
#   ! -e "$initfile" ||
#   "$initfile" -ot "${commands[starship]}" ||
#   -e "$starship_conf" &&
#   "$initfile" -ot "$starship_conf"
# ]]; then
#   $commands[starship] init zsh --print-full-init >| "$initfile"
#   zcompile -UR $initfile
# fi

$commands[starship] init zsh --print-full-init >| "$initfile"
source "$initfile"
