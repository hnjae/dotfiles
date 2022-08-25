#!/usr/bin/dash


case $1 in
	clipboard)
maim -i $(xdotool getactivewindow) --hidecursor | xclip -selection clipboard -t image/png \
	&& notify-send --app-name=maim --icon=maim \
		maim "Window captured to clipboard" \
	|| notify-send --app-name=maim --icon=maim \
		--urgency=critical maim "FAILED to capture window to clipboard"
		;;
	file)
	maim -i $(xdotool getactivewindow) -f png -m 10  --hidecursor  "$HOME/Pictures/$(date +%s)" \
	&& notify-send --app-name=maim --icon=maim \
		maim "Window captured to file" \
	|| notify-send --app-name=maim --icon=maim \
		--urgency=critical maim "FAILED to capture window to file"
		;;
	*)
	notify-send --app-name=maim --icon=maim --urgency=critical maim "failed"
		;;
esac
send_notification $1
