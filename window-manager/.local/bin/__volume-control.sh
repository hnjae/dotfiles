#!/usr/bin/sh

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

_get_volume () {
	pamixer --get-volume
}

VOLUME=`_get_volume`

btsink_vol() {
	# [ VOLUME != "50" ] && pamixer --set-volume 50

	echo $BLUEZ_PATH
	case $1 in
		up)
			dbus-send \
				--print-reply \
				--system \
				--dest=org.bluez \
				$BLUEZ_PATH \
				org.bluez.MediaControl1.VolumeUp
			;;
		down)
			dbus-send \
				--print-reply \
				--system \
				--dest=org.bluez \
				"$BLUEZ_PATH" \
				org.bluez.MediaControl1.VolumeDown
			;;
		*)
			;;
	esac
}



is_mute () {
	# return "true" or "false" to stdout
	# exit code 0 or 1
        [ $(pamixer --get-mute) = "true" ]
}

send_notification () {
	# DIR=`dirname "$0"`
	# Make the bar with the special character ─ (it"s not dash -)
	# https://en.wikipedia.org/wiki/Box-drawing_character
	#bar=$(seq -s "─" $(($volume/5)) | sed "s/[0-9]//g")

	if is_mute; then
		icon_name="audio-volume-muted"

		notify-send \
			--urgency="low" \
			--app-name="pulseaudio" \
			--icon="$icon_name" \
			"Volume" \
			"Muted"
	elif [ $IS_SINK_BT ]; then
		icon_name="audio-volume"
		case $1 in
			up)
				notify-send \
					--urgency="low" \
					--app-name="pulseaudio" \
					--icon="$icon_name" \
					"Bluetooth Volume Up"
				;;
			down)
				notify-send \
					--urgency="low" \
					--app-name="pulseaudio" \
					--icon="$icon_name" \
					"Bluetooth Volume Down"
				;;
		esac
	else
		if [ $VOLUME -lt 33 ]; then
			icon_name="audio-volume-low"
		elif [ $VOLUME -lt 67 ]; then
			icon_name="audio-volume-medium"
		else
			icon_name="audio-volume-high"
		fi

		notify-send \
			--urgency="low" \
			--app-name="pulseaudio" \
			--icon="$icon_name" \
			-h int:value:$VOLUME \
			"Volume"
	fi

}

case $1 in
	up)
                # Set the volume on (if it was muted)
                # Up the volume (+ 2%)
                # pactl set-sink-volume @DEFAULT_SINK@ +$2%
                [ $2 ] && pamixer --increase $2 || pamixer --increase 2
		;;
	down)
		# pactl set-sink-volume @DEFAULT_SINK@ -2%
                [ $2 ] && pamixer --decrease $2 || pamixer --decrease 2
		;;
	mute)
		# Toggle mute
		# pactl set-sink-mute @DEFAULT_SINK@ toggle
		pamixer --toggle-mute
		;;
	*)
            echo "$VOLUME"
		;;
esac
send_notification $1
