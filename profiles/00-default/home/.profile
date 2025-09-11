# shellcheck shell=sh
# NOTE: `zsh` 설정에서 sourch 하도록 설정해야 함.

if [ "$__DOT_PROFILE_SOURCED" != "" ]; then return; fi
export __DOT_PROFILE_SOURCED=1

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

export EDITOR="nvim"
export VISUAL="nvim"

export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export IPYTHONDIR="${XDG_STATE_HOME}/ipython"
export PYTHON_COLORS="1"
export PYTHON_HISTORY="${XDG_STATE_HOME}/python_history"
