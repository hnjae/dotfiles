if ((!$+commands[navi])) || [[ $TERM == "dumb" || $options[zle] != on ]]; then
    return
fi

__CHEATS_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/navi/cheats"

local initfile="${0:A:h}/_navi.zsh"
local sigfile="${initfile}.sig"
local sig="${commands[navi]:A}"

# Cache invalidation policy:
# - `-ot` catches ordinary in-place navi updates.
# - `${commands[navi]:A}` catches Nix/NixOS upgrades because the real store path changes.
#
# hyperfine, 2026-05-17:
# - hyperfine 1.20.0; zsh 5.9 (x86_64-pc-linux-gnu); navi 2.24.0
# - TERM=xterm-256color XDG_CONFIG_HOME=/tmp/navi-bench-config
# - zsh -fic ':'                                      3.5 ms ± 0.8 ms
# - zsh -fic 'source cached-hit.zsh'                  5.9 ms ± 1.1 ms
# - zsh -fic 'source always-regenerate.zsh'           9.5 ms ± 1.1 ms
# - navi widget zsh >/dev/null                        4.1 ms ± 0.6 ms
# - repeat 200 cached hit: 31.9 ms; repeat 200 always regenerate: 828.9 ms
# Repeated runs show the cache check/source path is about 26x cheaper than
# regenerating the widget script each time; single-run measurements are near
# hyperfine noise.
if [[
    ! -e "$initfile" ||
    "$initfile" -ot "${commands[navi]}" ||
    ! -e "$sigfile" ||
    "$(<"$sigfile")" != "$sig"
]]; then
    $commands[navi] widget zsh >|"$initfile" || return 1
    print -r -- "$sig" >|"$sigfile"
    zcompile -UR "$initfile"
fi

source "$initfile"

function __navi_select() {
    local term="$1"
    local file

    file="$(
        (
            fd "$term" "$__CHEATS_DIR" -e cheat -t f
        ) |
            sed -e "s|^$__CHEATS_DIR||g" -e "s|\.cheat$||g" |
            fzf --select-1 --exit-0 --preview='bat -l sh --color=always --italic-text=always --paging=never --decorations=never '"$__CHEATS_DIR"'/{}.cheat' |
            awk -v path="$__CHEATS_DIR" -v ext=".cheat" '{print path $0 ext}'
    )"

    echo "$file"
}

function navi-edit() {
    local file
    if [[ $1 != "" ]]; then
        file="$__CHEATS_DIR/$1.cheat"
    else
        file="$(__navi_select ".")"
        [[ $file == "" ]] && return
    fi

    nvim -- "$file"
}

function navi-show() {
    local file
    if [[ -n $1 && -f "$__CHEATS_DIR/$1.cheat" ]]; then
        file="$__CHEATS_DIR/$1.cheat"
    else
        local term
        if [[ $1 != "" ]]; then
            term="$1"
        else
            term="."
        fi

        file="$(__navi_select "$term")"
        [[ $file == "" ]] && return
    fi

    sed -e '/^\$/d' -- "$file" |
        bat -l sh --color=always --decorations=never --paging=never
}

alias -- na="navi"
alias -- ne="navi-edit"
alias -- nsh="navi-show"
