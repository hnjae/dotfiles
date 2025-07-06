if (( ! $+commands[nix] )); then
  return
fi

# export NIXPKGS_ALLOW_UNFREE=1
#
if (( $+commands[any-nix-shell] )); then
  local initfile="${0:A:h}/_any-nix-shell.zsh"
  # if [[
  #   ! -e "$initfile" ||
  #   "$initfile" -ot "${commands[any-nix-shell]}"
  # ]]; then
  #   $commands[any-nix-shell] zsh >| "$initfile"
  #   zcompile -UR "$initfile"
  # fi

  $commands[any-nix-shell] zsh >| "$initfile"
  zcompile -UR "$initfile"

  source "$initfile"
fi

export NIXPKGS_ALLOW_UNFREE=1

alias nx=nix

alias nxf="nix flake"
alias nxfsh="nix flake show"

alias nxsr="nix search nixpkgs"

alias nxs="nix shell --impure 'nixpkgs#"
alias nxr="nix run --impure 'nixpkgs#"
