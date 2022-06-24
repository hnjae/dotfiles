#!/usr/bin/env sh

path="$1"

current_machine="$(uname -s)"
case "$current_machine" in
    Linux*)
        abspath=$(readlink -f "$1")
        OPENER="${OPENER:-xdg-open}"
        ;;
    Darwin*)
        abspath=$(greadlink "$1")
        OPENER="${OPENER:-open}"
        ;;
    *)
        exit 1
        ;;
esac

EDITOR="${EDITOR:-nvim}"

mime_type=`file --brief --mime-type "$abspath"`
case "$mime_type" in
    text/*|application/json|application/x-wine-extension-ini)
        type "$EDITOR" > /dev/null 2>&1 < /dev/null && "$EDITOR" "$path" && exit 0
        # type vim > /dev/null 2>&1 < /dev/null && vim "$path" && exit 0
        # type vi > /dev/null 2>&1 < /dev/null && vi "$path" && exit 0
        ;;
    inode/x-empty)
        echo "MIME: $mime_type"
        ;;
    *)
        # type handlr > /dev/null 2>&1 < /dev/null && handlr open "$path" && exit 0
        type "$OPENER" > /dev/null 2>&1 < /dev/null && "$OPENER" "$path" && exit 0
        ;;
esac
