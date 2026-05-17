if ((!${+PAGER})); then
    if ((${+commands[less]})); then
        export PAGER=less
    else
        export PAGER=more
    fi
fi

if ((!${+LESS})); then
    export LESS='--ignore-case --jump-target=4 --LONG-PROMPT --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'
fi

# -s: file exists and is not empty
if [[ -z "${NO_COLOR}" || "$TERM" != "dumb" || -s "${HOME}/.dir_colors" ]]; then
    local initdircolors="${0:A:h}/_dircolors.zsh"
    local sigfile="${initdircolors}.sig"
    local dircolors_cmd="${commands[dircolors]}"
    local sig="${dircolors_cmd:A}"

    # Cache invalidation policy:
    # - `~/.dir_colors` mtime catches color database changes.
    # - `-ot` catches ordinary in-place dircolors/coreutils updates.
    # - `${commands[dircolors]:A}` catches Nix/NixOS upgrades because the real store path changes.
    #
    # hyperfine, 2026-05-17:
    # - hyperfine 1.20.0; zsh 5.9 (x86_64-pc-linux-gnu); dircolors coreutils 9.8
    # - zsh -fc ':'                                                       4.5 ms ± 0.8 ms
    # - zsh -fc 'source cached-hit.zsh'                                   5.5 ms ± 1.0 ms
    # - zsh -fc 'source always-regenerate.zsh'                            7.3 ms ± 1.2 ms
    # - dircolors --sh "$HOME/.dir_colors" >/dev/null                     1.4 ms ± 0.6 ms
    # - repeat 200 cached hit: 30.6 ms; repeat 200 dircolors: 252.3 ms
    # Repeated runs show the cache check/source path is about 8x cheaper than
    # running dircolors each time; single-run measurements are near hyperfine noise.
    if [[ 
        ! -e "$initdircolors" ||
        "$initdircolors" -ot "${HOME}/.dir_colors" ||
        "$initdircolors" -ot "$dircolors_cmd" ||
        ! -e "$sigfile" ||
        "$(<"$sigfile")" != "$sig" ]] \
        ; then
        "$dircolors_cmd" --sh "${HOME}/.dir_colors" >|"$initdircolors"
        print -r -- "$sig" >|"$sigfile"
        zcompile -UR "$initdircolors"
    fi

    source "$initdircolors"
fi

alias chmod='chmod --preserve-root -v'
alias chown='chown --preserve-root -v'

alias du="du -h"
alias df="df -H"

# cd to XDG directories
alias sxc='cd "${XDG_CONFIG_HOME:-$HOME/.config}"'
alias sxd='cd "${XDG_DATA_HOME:-$HOME/.local/share}"'
alias sxs='cd "${XDG_STATE_HOME:-$HOME/.local/state}"'

if ((${+commands[nvim]})); then
    alias vi="nvim"
    alias vimdiff='nvim -d'
else
    alias vi="vim"
    alias nvim="vim"
fi

alias cp="cp -i --preserve=all --reflink=auto"
alias mv="mv -i"
alias j="just"
alias je="just --edit"

alias fmime='file --mime-type --brief --'
alias xmime='xdg-mime query filetype'
alias nfd2nfc-dryrun='convmv -r -f utf8 -t utf8 --nfc .'
alias nfd2nfc-run='convmv -r -f utf8 -t utf8 --nfc --notest .'

alias oc="opencode"
alias ocp="opencode --port 49542"
