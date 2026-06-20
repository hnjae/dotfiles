#!/bin/sh

set -eu

BROWSER="com.brave.Browser.desktop"
VIDEO_PLAYER="mpv.desktop"
IMAGE_VIEWER="org.hnjae.kiriview.desktop"

main() {
    handlr set 'video/mp4' "$VIDEO_PLAYER"
    handlr set 'video/x-ms-wmv' "$VIDEO_PLAYER"
    handlr set "video/x-ms-asf" "$VIDEO_PLAYER"
    handlr set "video/x-matroska" "$VIDEO_PLAYER"
    handlr set "video/x-msvideo" "$VIDEO_PLAYER"
    handlr set "video/vnd.avi" "$VIDEO_PLAYER"
    handlr set "video/x-msvideo" "$VIDEO_PLAYER"

    handlr set "image/jpeg" "$IMAGE_VIEWER"

    # handlr set 'audio/*' org.fooyin.fooyin.desktop
    handlr set "x-scheme-handler/http" "$BROWSER"
    handlr set "x-scheme-handler/https" "$BROWSER"
    handlr set "text/html" "$BROWSER"

    handlr set "application/vnd.oasis.opendocument.text" "org.libreoffice.LibreOffice.writer.desktop"
    handlr set "application/vnd.oasis.opendocument.spreadsheet" "org.libreoffice.LibreOffice.calc.desktop"
    handlr set "application/vnd.oasis.opendocument.presentation" "org.libreoffice.LibreOffice.impress.desktop"
    handlr set "application/pdf" "org.kde.okular.desktop"
}

main
