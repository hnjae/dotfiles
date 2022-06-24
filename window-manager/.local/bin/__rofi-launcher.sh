#/usr/bin/sh

	# config.rasi 에서 설정돔
	# -combi-modi window#drun#run \
	# -show-icons \
	# -font "Monospace 14" \
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    DPI="0"
    ICON_SIZE="32"
else
    DPI="1"
    ICON_SIZE="64"
fi

rofi \
	-show combi \
	-hide-scrollbar \
	-terminal "$TERMINAL" \
	-theme-str "configuration {show-icons: true;} element-icon {size: $ICON_SIZE;}" \
        -dpi "$DPI"

	# -color-window "#000000, #000000, #000000" \
# -icon-theme
# 	-theme oxide-fix \
# user-theme 좋은 것 리스트
# * flat-orange
	# -theme flat-orange-fix  \
	# -theme glue_pro_blue \
