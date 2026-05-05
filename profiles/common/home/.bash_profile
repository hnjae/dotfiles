# shellcheck shell=bash

# XDG_BIN_DIR="${XDG_BIN_DIR:-${HOME}/.local/bin}"
# XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
# XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
# XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

dot_bashenv="${XDG_CONFIG_HOME}/bash/bashenv"
if [[ -r "$dot_bashenv" ]]; then
    # shellcheck source=/dev/null
    . "$dot_bashenv"
fi
unset dot_bashenv

if shopt -q login_shell && [[ -s "${HOME}/.profile" ]]; then
    # shellcheck source=/dev/null
    . "${HOME}/.profile"
fi

if [[ $- == *i* && -z "${__DOT_BASHRC_SOURCED-}" && -s "${HOME}/.bashrc" ]]; then
    # shellcheck source=/dev/null
    . "${HOME}/.bashrc"
fi
