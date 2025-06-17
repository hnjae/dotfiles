if (( ! $+commands[nix] )); then
  return
fi

export NIXPKGS_ALLOW_UNFREE=1

if (( $+commands[any-nix-shell] )); then
  local initfile="${0:A:h}/_any-nix-shell.zsh"
  # if [[
  #   ! -e "$initfile" ||
  #   "$initfile" -ot "${commands[any-nix-shell]}" ||
  # ]]
  # fi
  # zcompile -UR "$initfile"

  # $commands[any-nix-shell] zsh --info-right >| "$initfile"
  $commands[any-nix-shell] zsh >| "$initfile"
  source "$initfile"
fi
