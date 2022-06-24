#!/usr/bin/env sh

I3_CONFIG_DIR="${XDG_DATA_HOME:-$HOME/.config}/i3"
cat "$I3_CONFIG_DIR/conf.d/"* > "$I3_CONFIG_DIR/config"

if [ "$XDG_CURRENT_DESKTOP" = "i3" ]; then
    case "$1" in
        "reload")
            i3-msg reload && notify-send i3 reloaded
            ;;
        "restart")
            i3-msg restart && notify-send i3 restarted
            ;;
    esac
fi
