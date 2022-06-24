#!/usr/bin/bash

## Created By Aditya Shakya
# *Lock) i3lock-fancy ;;
	# -font "Monospace 26" \

# 
#  hibernate
#  Switch usee
# 鈴 Suspend

MENU="$( \
	rofi -sep "|" -dmenu -i \
	-p 'System' \
	-width 16 -lines 4 \
	<<< " Lock| Logout|ﰇ Reboot|襤 Poweroff" \
	)"
            case "$MENU" in
                *Lock) i3lock-enhanced ;;
                *Logout) i3-msg exit ;;
                *Reboot) systemctl reboot ;;
                *Suspend) systemctl suspend ;;
                *Poweroff) systemctl -i poweroff
            esac
