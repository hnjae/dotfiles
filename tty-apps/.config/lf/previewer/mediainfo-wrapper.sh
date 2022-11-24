#!/usr/bin/env sh

[ "$#" -eq 0 ] && exit 0
type mediainfo > /dev/null || echo "mediainfo not installed." || exit 0

for file in "$@"; do
    [ -s "$file" ] && mediainfo -- "$file" \
        | sed '/^Complete name/d' \
        | sed '/^Format\/Info/d' \
        | sed '/^Codec ID\/Info/d' \
        | sed '/^Format settings, CABAC/d' \
        | sed '/^Format settings, Reference frames/d' \
        | sed '/^Stream size/d' \
        | sed '/^Source stream size/d' \
        | sed '/^Minimum frame rate/d' \
        | sed '/^Color space/d' \
        | sed '/^Color range/d' \
        | sed '/^Forced/d' \
        | sed '/^Compression mode/d' \
        | sed '/^Default/d' \
        | sed '/^Alternate group/d' \
        | sed '/^Color primaries/d' \
        | sed '/^Matrix coefficients/d' \
        | sed '/^Overall bit rate/d' \
        | sed '/^Channel layout/d'
done
