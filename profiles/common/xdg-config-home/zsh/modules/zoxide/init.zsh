if ((!$+commands[zoxide])); then
    return
fi

export _ZO_EXCLUDE_DIRS="$HOME:/nix/*:/mnt/*:/media/*:/run/mount/*:/run/media/*:/proc/*:*/.git:*/.git/*:*/.cache:*/.cache/*:*/.direnv:*/.direnv/*:*/dist:*/dist/*:*/.venv:*/.venv/*"
# `_ZO_FZF_OPTS` 없으면 fzf 의 extended-search 가 작동하지 않는다. fzf 를 안사용하게 되나? <2025-04-11>
export _ZO_FZF_OPTS="${FZF_DEFAULT_OPTS} --scheme=path"
export _ZO_MAXAGE="5000" # default 10000

local initfile="${0:A:h}/_zoxide.zsh"
local sigfile="${initfile}.sig"
local sig="${commands[zoxide]:A}"

# Cache benchmark:
# zoxide init is much cheaper than devenv hook, so this cache is mostly for
# consistency and avoiding unnecessary regeneration, not for a large startup win.
#
# hyperfine --warmup 10 --runs 100, 2026-05-17:
# - hyperfine 1.20.0; zsh 5.9 (x86_64-pc-linux-gnu); zoxide 0.9.9
# - zsh -fc ':'                                             2.7 ms ± 0.7 ms
# - zsh -fc 'source always-regenerate.zsh'                  5.9 ms ± 1.2 ms
# - zsh -fc 'source cached-hit.zsh'                         4.7 ms ± 1.3 ms
# - zoxide init zsh --no-cmd >/dev/null                   953.7 us ± 425.9 us
# Cache hit is only modestly faster than regenerating, but still avoids about 1 ms
# on this machine and keeps the generated init file stable between upgrades.
if [[ 
    ! -e "$initfile" ||
    "$initfile" -ot "${commands[zoxide]}" ||
    ! -e "$sigfile" ||
    "$(<"$sigfile")" != "$sig" ]] \
    ; then

    $commands[zoxide] init zsh --no-cmd >|"$initfile"
    print -r -- "$sig" >|"$sigfile"

    # zcompile note:
    # `source "$initfile"` automatically uses "$initfile.zwc" when the .zwc file is newer.
    #
    # hyperfine --warmup 10 --runs 100, 2026-05-17:
    # - hyperfine 1.20.0; zsh 5.9 (x86_64-pc-linux-gnu); zoxide 0.9.9
    # - zsh -fc ':'                                             2.7 ms ± 0.7 ms
    # - zsh -fc 'source plain/_zoxide.zsh'                      3.2 ms ± 0.7 ms
    # - zsh -fc 'source compiled/_zoxide.zsh'                   3.5 ms ± 1.0 ms
    #
    # hyperfine --warmup 5 --runs 50, 2026-05-17:
    # - zsh -fc 'repeat 1000; do source plain/_zoxide.zsh; done'    209.7 ms ± 5.6 ms
    # - zsh -fc 'repeat 1000; do source compiled/_zoxide.zsh; done'  32.7 ms ± 4.0 ms
    # Per-source parsing cost is lower with .zwc, but this file is sourced once per shell
    # startup, so the real startup win is below the single-run measurement noise.
    zcompile -UR "$initfile"
fi

source "$initfile"

function cd() {
    if [[ $# -gt 0 && $1 == "--" ]]; then
        shift
    fi

    if [[ $# -eq 0 ]]; then
        return 0
    fi

    if [[ $# -gt 1 ]]; then
        print -u2 "cd: too many arguments"
        return 1
    fi

    if [[ -f $1 ]]; then
        __zoxide_z "$(dirname "$1")"
    elif [[ -d $1 ]]; then
        __zoxide_z "$1"
    else
        print -u2 "cd: $1: No such file or directory"
        return 1
    fi
}

function s() {
    if [[ $# -gt 0 && $1 == "--" ]]; then
        shift
    fi

    if [[ $# -eq 0 ]]; then
        return 0
    fi

    if [[ $# -gt 1 ]]; then
        print -u2 "zoxide: too many arguments"
        return 1
    fi

    if [[ -f $1 ]]; then
        __zoxide_z "$(dirname "$1")"
    elif [[ -d $1 ]]; then
        __zoxide_z "$1"
    else
        print -u2 "zoxide: $1: No such file or directory"
        return 1
    fi
}

function si() {
    __zoxide_zi "$@"
}
