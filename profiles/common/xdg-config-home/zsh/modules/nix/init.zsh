if ((!$+commands[nix])); then
    return
fi

# alias nx=nix
alias nf="nix flake"
alias nfh="nix flake show"
alias nsp="nix search nixpkgs"
alias ns="nix shell --impure 'nixpkgs#"
alias nx="nix run --impure 'nixpkgs#"

# HACK: shfmt 가 현재 `$commands[oh-my-posh]` 를 `$commands[oh - my - - posh]` 로 포맷팅해서 별도 변수 사용. <shfmt 3.13.1; 2026-05-09>
typeset cmd="any-nix-shell"

if (($+commands[$cmd])); then
    local initfile="${0:A:h}/_any-nix-shell.zsh"
    local sigfile="${initfile}.sig"
    local sig="${commands[$cmd]:A}"

    # Cache invalidation policy:
    # - `-ot` catches ordinary in-place any-nix-shell updates.
    # - `${commands[any-nix-shell]:A}` catches Nix/NixOS upgrades because the real store path changes.
    #
    # hyperfine, 2026-05-17:
    # - hyperfine 1.20.0; zsh 5.9 (x86_64-pc-linux-gnu); any-nix-shell 2.0.1
    # - zsh -fc ':'                                      2.9 ms ± 0.7 ms
    # - zsh -fc 'source cached-hit.zsh'                  4.9 ms ± 1.0 ms
    # - zsh -fc 'source always-regenerate.zsh'          12.8 ms ± 1.4 ms
    # - any-nix-shell zsh >/dev/null                     7.4 ms ± 0.4 ms
    # - repeat 200 cached hit: 30.6 ms; repeat 200 always regenerate: 1.643 s
    # Repeated runs show the cache check/source path is about 54x cheaper than
    # regenerating the init script each time; single-run cache hit is close to
    # hyperfine noise but still avoids the any-nix-shell process.
    if [[ 
        ! -e "$initfile" ||
        "$initfile" -ot "${commands[$cmd]}" ||
        ! -e "$sigfile" ||
        "$(<"$sigfile")" != "$sig" ]] \
        ; then
        $commands[$cmd] zsh >|"$initfile" || return 1
        print -r -- "$sig" >|"$sigfile"
        zcompile -UR "$initfile"
    fi

    source "$initfile"
fi

unset cmd
