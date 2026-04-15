if (( ! $+commands[yazi])); then
    return
fi

mkdir -p "/tmp/$USER/yazi-cwd"

function e() {
    local cwd_file
    cwd_file="/tmp/$USER/yazi-cwd/$RANDOM"

    # `command` is needed in case something is aliased to `yazi`
    command yazi --cwd-file="$cwd_file" "$@"
    if [[ -f $cwd_file ]]; then
        if cwd="$(cat "$cwd_file")" && [[ -n $cwd ]] &&
            [[ -d $cwd && $cwd != "${PWD:-$(pwd)}" ]]; then
            cd -- "$cwd" || return
        fi

        rm -f -- "$cwd_file"
    fi
}
