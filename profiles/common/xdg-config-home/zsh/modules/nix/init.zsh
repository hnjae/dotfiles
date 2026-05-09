if ((!$+commands[nix])); then
    return
fi

# export NIXPKGS_ALLOW_UNFREE=1
#
# HACK: shfmt 가 현재 `$commands[oh-my-posh]` 를 `$commands[oh - my - - posh]` 로 포맷팅해서 별도 변수 사용. <shfmt 3.13.1; 2026-05-09>
typeset cmd="any-nix-shell"

if (($+commands[$cmd])); then
    local initfile="${0:A:h}/_any-nix-shell.zsh"
    # if [[
    #   ! -e "$initfile" ||
    #   "$initfile" -ot "${commands[any-nix-shell]}"
    # ]]; then
    #   $commands[any-nix-shell] zsh >| "$initfile"
    #   zcompile -UR "$initfile"
    # fi

    $commands[$cmd] zsh >|"$initfile"
    zcompile -UR "$initfile"

    source "$initfile"
fi

# alias nx=nix

alias nf="nix flake"
alias nfh="nix flake show"
alias nsp="nix search nixpkgs"
alias ns="nix shell --impure 'nixpkgs#"
alias nx="nix run --impure 'nixpkgs#"

unset cmd
