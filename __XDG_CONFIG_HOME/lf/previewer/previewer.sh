#!/usr/bin/env sh

current_machine="$(uname -s)"
case "$(current_machine)" in
    Linux*)
        filepath=$(readlink -f "$1")
        ;;
    Darwin*)
        filepath=$(greadlink -f "$1")
        ;;
    *)
        exit 1
        ;;
esac

# unset COLORTERM

# IMG_CACHE_SIZE=4096x2160
IMG_CACHE_SIZE=1920x1080
IMG_CACHE_SIZE_S=1080

image() {
	if [ -n "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
		printf '{"action": "add", "identifier": "PREVIEW", "x": "%s", "y": "%s", "width": "%s", "height": "%s", "scaler": "contain", "path": "%s"}\n' "$4" "$5" "$(($2-1))" "$(($3-1))" "$1" > "$FIFO_UEBERZUG"
		exit 1
	else
		# chafa "$filepath" -s "$4x"
                h=`expr $3 - 1`
                chafa "$1" -f symbols -s "$2x$h"
	fi
}


# echo "$filepath"
# echo "$2" #width
[ ! -z "$2" ] && t_width="$2"
# echo "$3" #height
# echo "$4"
# echo "$5"
# echo "$6"

img_cache() {
    [ ! -d "${XDG_CACHE_HOME:-$HOME/.cache}/lf" ] && mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/lf"
    echo "${XDG_CACHE_HOME:-$HOME/.cache}/lf/thumbnail.$(stat --printf '%i\0%F\0%s\0%W\0%Y' -- "$filepath" | xxh64sum | awk '{print $filepath}').jpg"
}

PREVIEWERS="${XDG_CONFIG_HOME:-$HOME/.config}/lf/previewer"
FILE_EXTENSION="${1##*.}"
# FILE_EXTENSION_LOWER=$(echo ${FILE_EXTENSION} | tr '[:upper:]' '[:lower:]')


mime_type=`file --brief --mime-type "$filepath"`

case "$FILE_EXTENSION" in
    cbz)
        cache=`img_cache "$filepath"`
        if [ -s "$cache" ]; then
            prev_file="$cache"
        else
            comicthumb "$filepath" "$cache" "$IMG_CACHE_SIZE_S"
        fi

        prev_file="$cache"
        [ ! -z "$2" ] \
            && image "$prev_file" "$2" "$3" "$4" "$5" "$6" \
            || image "$prev_file" `tput cols` `tput lines`
        exit 0
        ;;
    *)
        ;;
esac

case "$mime_type" in
    # "inode/x-empty")
    #     echo "MIME: inode/x-empty"
    #     ;;
    # application/zip|application/x-bzip2)
    text/*|application/json|application/x-wine-extension-ini)
        # bat default theme: monokai
        # if [ "$FILE_EXTENSION" = "conf" ]; then
        #     lang="--language=ini"
        # fi
        if [ ! -z "$t_width" ]; then
            bat --style=plain \
                --color=always \
                --paging=never \
                --italic-text=always \
                --wrap=character \
                --terminal-width="$t_width" \
                -- "$filepath" | head -3000 \
        else
            bat --style=plain \
                --color=always \
                --paging=never \
                --italic-text=always \
                --wrap=character \
                --terminal-width=80 \
                -- "$filepath"
        fi
        ;;
    application/zip|application/x-bzip2|application/gzip|application/x-xz|application/zstd|application/x-archive)
        # 7z l -- "$filepath" | tac
        "$PREVIEWERS/7z-wrapper.sh" -- "$filepath"
        ;;
    application/vnd.oasis.opendocument.text)
        odt2txt "$filepath"
        ;;
    application/pdf)
        "$PREVIEWERS/exiftool-wrapper.sh" -- "$filepath"
        echo "-----------------------------"
        pdftotext -l 10 -nopgbrk -q -- "$filepath" -
        ;;
    video/*)
        # cache=`img_cache "$filepath"`
        # if [ ! -s "$cache" ]; then
        #     vcs "$filepath" -n 6 -c 2 -H 400 -A -j -dp -ds -dt -O bg_all=black -O fg_all=white --anonymous -o "$cache"
        # fi
        "$PREVIEWERS/mediainfo-wrapper.sh" -- "$filepath"
        # prev_file="$cache"
        # [ ! -z "$2" ] \
        #     && image "$prev_file" "$2" "$3" "$4" "$5" "$6" \
        #     || image "$prev_file" `tput cols` `tput lines`
        ;;
    audio/*)
        "$PREVIEWERS/exiftool-wrapper.sh" -- "$filepath"
        ;;
    image/*)
        # echo `img_cache $filepath`
        # echo `img_cache $filepath`
        cache=`img_cache "$filepath"`
        if [ -s "$cache" ]; then
            prev_file="$cache"
        else
            orientation="$( identify -format '%[EXIF:Orientation]\n' -- "$filepath" )"
            if [ -n "$orientation" -a "$orientation" != 1 ]; then
                convert -- "$filepath" -auto-orient -resize $IMG_CACHE_SIZE\> -quality 50 "$cache"
                prev_file="$cache"
            else
                prev_file="$filepath"
            fi
        fi

        [ ! -z "$2" ] \
            && image "$prev_file" "$2" "$3" "$4" "$5" "$6" \
            || image "$prev_file" `tput cols` `tput lines`
        exiftool -- "$filepath" | grep -i "^Image Size"  | sed -e 's/.*\: //'

        # chafa "$filepath" -s "$4x"
        # image "${CACHE}.jpg" "$2" "$3" "$4" "$5"
        # img2sixel -h "$3" -w "$2" -- "$filepath"
        # 444:                ['img2sixel', '-h', f'{output_h}', '-w', f'{output_w}', path],
        ;;
    inode/directory)
        exa --tree --icons --group --time-style long-iso --level=1 -- "$filepath"
        ;;
    inode/x-empty)
        echo "MIME: $mime_type"
        ;;
    *)
        echo "----- File Type Classification -----"
        echo "MIME: $mime_type"
        type hexyl > /dev/null \
            && hexyl --block-size=4096 --length=1block -- "$filepath" \
            || od --format=xz -N 4096 --address-radix=n -- "$filepath"
        ;;
esac

# --italic-text=always  won't work
# bat --style=plain --italic-text=always --color=always --paging=never "$filepath"
