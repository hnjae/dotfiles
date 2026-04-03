if (( ! $+commands[yazi])); then
    return
fi

XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"

function y() {
    local tmp
    tmp="${XDG_CACHE_HOME}/yazicd/$RANDOM"

    # `command` is needed in case something is aliased to `yazi`
    command yazi --cwd-file="$tmp" "$@"
    if [[ -f $tmp ]]; then
        if cwd="$(cat "$tmp")" && [[ -n $cwd ]] &&
            [[ -d $cwd && $cwd != "${PWD:-$(pwd)}" ]]; then
            cd -- "$cwd" || return
        fi

        rm -f -- "$tmp"
    fi
}
