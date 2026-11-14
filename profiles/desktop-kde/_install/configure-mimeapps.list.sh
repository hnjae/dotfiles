#!/bin/sh

set -eu

BROWSER="com.brave.Browser.desktop"
# BROWSER="firefox.desktop"
VIDEO_PLAYER="mpv.desktop"
IMAGE_VIEWER="org.hnjae.kiriview.desktop"

# Every set rewrites mimeapps.list, so compare with the current handler first.
set_mime() {
    _current="$(handlr get "$1" 2>/dev/null || true)"
    if [ "$_current" = "$2" ]; then
        return 0
    fi
    handlr set "$1" "$2"
}

set_browser() {
    _current="$(xdg-settings get default-web-browser 2>/dev/null || true)"
    if [ "$_current" = "$1" ]; then
        return 0
    fi
    xdg-settings set default-web-browser "$1"
}

# NOTE: query filetype via `xdg-mime query filetype`
main() {
    # xdg-mime's of video files
    set_mime "video/vnd.avi" "$VIDEO_PLAYER"                # .avi
    set_mime "video/x-matroska" "$VIDEO_PLAYER"             # .mkv
    set_mime 'application/vnd.rn-realmedia' "$VIDEO_PLAYER" # .rmvb
    set_mime 'video/mp4' "$VIDEO_PLAYER"                    # .mp4
    set_mime 'video/mpeg' "$VIDEO_PLAYER"                   # .mpeg
    set_mime 'video/ogg' "$VIDEO_PLAYER"                    # .ogv
    set_mime 'video/webm' "$VIDEO_PLAYER"                   # .webm
    set_mime 'video/x-ms-wmv' "$VIDEO_PLAYER"               # .wmv

    # xdg-mime's of image files
    set_mime "image/apng" "$IMAGE_VIEWER"
    set_mime "image/avif" "$IMAGE_VIEWER"
    set_mime "image/bmp" "$IMAGE_VIEWER"
    set_mime "image/gif" "$IMAGE_VIEWER"
    set_mime "image/jp2" "$IMAGE_VIEWER"
    set_mime "image/jpeg" "$IMAGE_VIEWER"
    set_mime "image/jxl" "$IMAGE_VIEWER"
    set_mime "image/png" "$IMAGE_VIEWER"
    set_mime "image/svg+xml" "$IMAGE_VIEWER"
    set_mime "image/tiff" "$IMAGE_VIEWER"
    set_mime "image/webp" "$IMAGE_VIEWER"
    set_mime "image/x-adobe-dng" "$IMAGE_VIEWER"

    # BROWSER
    set_mime "x-scheme-handler/http" "$BROWSER"
    set_mime "x-scheme-handler/https" "$BROWSER"
    set_mime "text/html" "$BROWSER"
    set_browser "$BROWSER"

    # Miscellaneous
    set_mime "application/vnd.oasis.opendocument.text" "org.libreoffice.LibreOffice.writer.desktop"
    set_mime "application/vnd.oasis.opendocument.spreadsheet" "org.libreoffice.LibreOffice.calc.desktop"
    set_mime "application/vnd.oasis.opendocument.presentation" "org.libreoffice.LibreOffice.impress.desktop"
    set_mime "application/pdf" "org.kde.okular.desktop"
}

main
