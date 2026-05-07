# shellcheck shell=bash

if command -v oh-my-posh > /dev/null 2>&1; then
    eval "$(command oh-my-posh init bash --config "${XDG_CONFIG_HOME:-${HOME}/.config}/oh-my-posh.json")"
fi
