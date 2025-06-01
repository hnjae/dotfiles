if (( ! $+commands[nix] )); then
  return
fi

export NIXPKGS_ALLOW_UNFREE=1

if (( $+commands[any-nix-shell] )); then
  # any-nix-shell zsh --info-right >| source /dev/stdin
  $commands[any-nix-shell] any-nix-shell zsh --info-right >| ${0:A:h}/any-nix-shell.zsh
  source ${0:A:h}/any-nix-shell.zsh
fi
