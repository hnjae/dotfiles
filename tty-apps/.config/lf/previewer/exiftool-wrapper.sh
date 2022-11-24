#!/usr/bin/env sh

[ "$#" -eq 0 ] && exit 0
type exiftool > /dev/null || echo "exiftool not installed." || exit 0

        # | sed '/^MIME Type/d' \
        # | sed '/^File Type/d' \
for file in "$@"; do
    [ -s "$file" ] && exiftool -- "$file" \
        | sed '/^ExifTool Version Number/d' \
        | sed '/^File Size/d' \
        | sed '/^File Name/d' \
        | sed '/^Directory/d' \
        | sed '/^File.*Date.*:/d' \
        | sed '/^File Permissions/d' \
        | sed '/^Linearized/d'
done
