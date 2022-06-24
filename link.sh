#!/usr/bin/env sh

mkdir -p "$HOME/.hammerspoon"
stow -nv --stow --target="$HOME/.hammerspoon" .
