#!/usr/bin/dash

curVal=$( \
	echo "(`brightnessctl \
		--device=asus::kbd_backlight get` * 100 + 1.5) / 3" \
	| bc \
)

	# --icon="keyboard-brightness,keyboard-brightness-symbolic,input-keyboard,input-keyboard-symbolic" \
notify-send \
	--urgency="low" \
	--app-name=xbacklight \
	--icon="keyboard-brightness-symbolic" \
	-h int:value:$curVal \
	"Keyboard Brightness"
