# shellcheck shell=bash

if ! command -v zoxide > /dev/null 2>&1; then
    return
fi

export _ZO_EXCLUDE_DIRS="$HOME:/nix/*:/mnt/*:/media/*:/run/mount/*:/run/media/*:/proc/*:*/.git:*/.git/*:*/.cache:*/.cache/*:*/.direnv:*/.direnv/*:*/dist:*/dist/*:*/.venv:*/.venv/*"
export _ZO_FZF_OPTS="${FZF_DEFAULT_OPTS} --scheme=path"
export _ZO_MAXAGE="2500"

__zoxide_cache_dir="${XDG_CACHE_HOME:-${HOME}/.cache}/bash/zoxide"
__zoxide_init_file="${__zoxide_cache_dir}/init.bash"
__zoxide_bin="$(command -v zoxide)"

command mkdir -p "$__zoxide_cache_dir" || return

if [[ ! -s "$__zoxide_init_file" || "$__zoxide_init_file" -ot "$__zoxide_bin" ]]; then
    __zoxide_tmp="${__zoxide_init_file}.$$"
    if command zoxide init bash --no-cmd > "$__zoxide_tmp"; then
        command mv -f "$__zoxide_tmp" "$__zoxide_init_file"
    else
        command rm -f "$__zoxide_tmp"
        return 1
    fi
fi

# shellcheck source=/dev/null
. "$__zoxide_init_file"

unset __zoxide_cache_dir __zoxide_init_file __zoxide_bin __zoxide_tmp

cd() {
    if [[ $# -gt 0 && $1 == "--" ]]; then
        shift
    fi

    if [[ $# -eq 0 ]]; then
        return 0
    fi

    if [[ $# -gt 1 ]]; then
        printf 'cd: too many arguments\n' >&2
        return 1
    fi

    if [[ -f $1 ]]; then
        __zoxide_z "$(command dirname -- "$1")"
    elif [[ -d $1 ]]; then
        __zoxide_z "$1"
    else
        printf 'cd: %s: No such file or directory\n' "$1" >&2
        return 1
    fi
}

s() {
    if [[ $# -gt 0 && $1 == "--" ]]; then
        shift
    fi

    if [[ $# -gt 0 && -f "$*" ]]; then
        __zoxide_z "$(command dirname -- "$*")"
    else
        __zoxide_z "$@"
    fi
}

si() {
    __zoxide_zi "$@"
}
