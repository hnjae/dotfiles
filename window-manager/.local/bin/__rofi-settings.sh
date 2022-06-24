#!/bin/bash

## Created By Aditya Shakya
# *Lock) i3lock-fancy ;;
# -font "Monospace 26" \
# -padding 20 -line-padding 4
MENU="$(\
	rofi -sep "|" -dmenu -i \
	-p 'Settings' \
	-width 18 -lines 9 \
	<<< " : arandr| : fcitx5-config|醙 : pavucontrol|> : paprefs|朗 : system-config-printer| : blueman| : blueman-assistant| : nm-connection-editor| : gnome-logs"\
	)"
            case "$MENU" in
		*arandr) arandr;;
                *fcitx5-config) fcitx5-config-qt;;
                *pavucontrol) pavucontrol;;
                *paprefs) paprefs;;
                *system-config-printer) system-config-printer;;
                *blueman) blueman-manager;;
		*blueman-assistant) blueman-assistant;;
		*nm-connection-editor) nm-connection-editor;;
		*gnome-logs) gnome-logs
            esac
