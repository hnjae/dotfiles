#!/usr/bin/env sh

path="$1"
abspath=$(readlink -f "$1")

mime_type=`file --brief --mime-type "$abspath"`
case "$mime_type" in
    text/*|application/json|application/x-wine-extension-ini)
        type "$EDITOR" > /dev/null 2>&1 < /dev/null && "$EDITOR" "$path" && exit 0
        type vim > /dev/null 2>&1 < /dev/null && vim "$path" && exit 0
        type vi > /dev/null 2>&1 < /dev/null && vi "$path" && exit 0
        ;;
    inode/x-empty)
        echo "MIME: $mime_type"
        ;;
    *)
        type handlr > /dev/null 2>&1 < /dev/null && handlr open "$path" && exit 0
        type "$OPENER" > /dev/null 2>&1 < /dev/null && "$OPENER" "$path" && exit 0
        type xdg-open > /dev/null 2>&1 < /dev/null && xdg-open "$path" && exit 0
        ;;
esac
