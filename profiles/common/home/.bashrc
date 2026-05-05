# shellcheck shell=bash

__DOT_BASHRC_SOURCED=1

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

# shellcheck source=/dev/null
source "${XDG_CONFIG_HOME}/bash/bashrc"
