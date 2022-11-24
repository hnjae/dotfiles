#!/usr/bin/env sh

[ "$#" -eq 0 ] && exit 0
type 7z > /dev/null || echo "7z not installed." || exit 0

for file in "$@"; do
    [ -s "$file" ] && 7z l -- "$file" \
        | sed '/^7-Zip \[64\]/d' \
        | sed '/^p7zip Version/d' \
        | sed '/^Listing archive:/d' \
        | sed '/^Scanning the drive for archives/d' \
        | sed '/^Path = /d' \
        | sed '/^--$/d' \
        | sed '/^$/d' \
        | sed '1d' \
        | tac
done
