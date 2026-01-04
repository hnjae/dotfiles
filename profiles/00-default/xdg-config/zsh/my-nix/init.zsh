if (( ! $+commands[nix] )); then
    return
fi

# export NIXPKGS_ALLOW_UNFREE=1
#
if (($ + commands[any - nix - shell])); then
    local initfile="${0:A:h}/_any-nix-shell.zsh"
    # if [[
    #   ! -e "$initfile" ||
    #   "$initfile" -ot "${commands[any-nix-shell]}"
    # ]]; then
    #   $commands[any-nix-shell] zsh >| "$initfile"
    #   zcompile -UR "$initfile"
    # fi

    $commands[any-nix-shell] zsh >|"$initfile"
    zcompile -UR "$initfile"

    source "$initfile"
fi

export NIXPKGS_ALLOW_UNFREE=1

# alias nx=nix

alias nixf="nix flake"
alias nixfsh="nix flake show"
alias nixsr="nix search nixpkgs"
alias nixs="nix shell --impure 'nixpkgs#"
alias nixr="nix run --impure 'nixpkgs#"
