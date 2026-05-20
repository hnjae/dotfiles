# shellcheck shell=bash

__fzf_marker="$(printf '\342\226\221')"
export FZF_DEFAULT_OPTS="--color=base16,border:8 --layout=reverse --smart-case --height=22 --marker=${__fzf_marker}"
unset __fzf_marker

if command -v fzf >/dev/null 2>&1; then
    eval "$(command fzf --bash)"
fi
