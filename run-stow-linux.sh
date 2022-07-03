#!/usr/bin/env sh

# read_char() {
#   stty -icanon -echo
#   eval "$1=\$(dd bs=1 count=1 2>/dev/null)"
#   stty icanon echo
# }

which stow > /dev/null 2>&1 || echo "stow is not installed" || exit 1

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_CONFIG_HOME/smplayer"
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/zsh"

stow -nv --stow --target="$XDG_CONFIG_HOME" "__XDG_CONFIG_HOME"
stow -nv --stow --target="$XDG_CONFIG_HOME/smplayer" "smplayer"
stow -nv --stow --target="$HOME" "__HOME--ZEPHY-G15"
stow -nv --stow --target="$HOME" "window-manager"
stow -nv --stow --target="$HOME" "shell"
stow -nv --stow --target="$HOME/.local/bin" "__MY_BIN"

read -p "Continue? (y/Any)" should_run
[ "$should_run" != "y" ] && echo "O.K. No" && exit 1


stow -v --stow --target="$XDG_CONFIG_HOME" "__XDG_CONFIG_HOME"
stow -v --stow --target="$XDG_CONFIG_HOME/smplayer" "smplayer"
stow -v --stow --target="$HOME" "__HOME--ZEPHY-G15"
stow -v --stow --target="$HOME" "window-manager"
stow -v --stow --target="$HOME" "shell"
stow -v --stow --target="$HOME/.local/bin" "__MY_BIN"
