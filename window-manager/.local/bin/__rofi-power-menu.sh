#/usr/bin/sh

# https://github.com/jluttine/rofi-power-menu

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    DPI="0"
    THEME="window {width: 360px; height: 200px;} listview {scrollbar: false;}"
else
    DPI="1"
    THEME="window {width: 720px; height: 400px;} listview {scrollbar: false;}"
fi

rofi \
	-show session-menu \
	-theme gruvbox-dark-hard \
	-modi "session-menu:rofi-power-menu --choices=shutdown/reboot/lockscreen/logout/suspend --confirm=reboot/logout/suspend/shutdown" \
        -fixed-num-lines \
        -lines 5 \
        -dpi "$DPI" \
	-theme-str "$THEME"
	#-theme-str "window {width: 360px; height: 200px;} listview {scrollbar: false;}"
