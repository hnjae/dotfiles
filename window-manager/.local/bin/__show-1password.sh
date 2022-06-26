#!/usr/bin/env sh

# pgrep -x "1password" > /dev/null
# if [ "$?" -eq "0" ]; then


if `pgrep -x "1password" > /dev/null`; then
    # echo "running"
    if `wmctrl -l | grep -E ".*1Password\$" > /dev/null`; then
        if [ "$XDG_CURRENT_DESKTOP" = "sway" ]; then
            swaymsg '[instance="1password"]' scratchpad show
        elif [ "$XDG_CURRENT_DESKTOP" = "i3" ]; then
            i3-msg '[instance="1password"]' scratchpad show
        elif [ -z "$XDG_CURRENT_DESKTOP" ]; then
            echo "XDG_CURRENT_DESKTOP is not set"
            notify-send "XDG_CURRENT_DESKTOP is not set"
        else
            echo "NOT SUPPORTED DE: $XDG_CURRENT_DESKTOP"
            notify-send "NOT SUPPORTED DE: $XDG_CURRENT_DESKTOP"
        fi
    else
        1password --toggle
    fi
else
    # run 1password if not present
    # echo "not running"
    if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
        nohup env GDK_SCALE=1 GDK_DPI_SCALE=1.0 1password --silent \
            < /dev/null > /dev/null &
    else
        nohup 1password --silent \
            < /dev/null > /dev/null &
    fi
    sleep 0.8
    1password --toggle
fi
