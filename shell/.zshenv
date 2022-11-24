#!/usr/bin/env zsh

# export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
# export ZDOTDIR="${ZDOTDIR:=$XDG_CONFIG_HOME/zsh}"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# -r: if file exists and is readable
[ -r "$ZDOTDIR/.zshenv" ] && source "$ZDOTDIR/.zshenv"
