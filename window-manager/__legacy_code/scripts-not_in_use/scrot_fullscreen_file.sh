#!/usr/bin/dash

# maim -i $(xdotool getactivewindow) | xclip -selection clipboard -t image/png && \
# 	notify-send maim "Window Captured to clipboard"

# [ -z ${XDG_PICTURES_DIR+x} ] && save_dir="$XDG_PICTURES_DIR/Screenshots/$date" || echo "configured


[ -z "${XDG_PICTURES_DIR+x}" ] \
	&& save_dir="$HOME/Pictures/Screenshots" \
	|| save_dir="$XDG_PICTURES_DIR/Screenshots"

[ -d "$save_dir" ] || mkdir -p "$save_dir"

date=`date '+%Y%m%d-%H%M%S%z'`

date_raw=`date '+%Y%m%d-%H%M%S.%N'`
save_raw="/tmp/$date_raw.png"

scrot --overwrite --quality 0 "$save_raw" \
	&& cwebp -q 100 -z 9 -lossless "$save_raw" -o "$save_dir/$date.webp" \
	&& notify-send --app-name=maim --icon=maim \
		scrot "Screen captured to file" \
	|| notify-send --app-name=maim --icon=maim --urgency=critical \
		scrot "FAILED to capture screen to file"

rm "$save_raw"

# avifenc provides larger file than cwebp!
# avifenc --jobs 16 --speed 0 --yuv 420 "$save_raw" --output "$save_dir/$date.avif"
