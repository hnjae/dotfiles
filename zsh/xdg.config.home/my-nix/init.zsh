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

alias n=nix

alias nf="nix flake"
alias nfsh="nix flake show"

alias nsr="nix search nixpkgs"

alias ns="nix shell --impure 'nixpkgs#"
alias nr="nix run --impure 'nixpkgs#"
