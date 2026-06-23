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

    # xdg-mime of image files
    handlr set "image/apng" "$IMAGE_VIEWER"
    handlr set "image/avif" "$IMAGE_VIEWER"
    handlr set "image/bmp" "$IMAGE_VIEWER"
    handlr set "image/gif" "$IMAGE_VIEWER"
    handlr set "image/jp2" "$IMAGE_VIEWER"
    handlr set "image/jpeg" "$IMAGE_VIEWER"
    handlr set "image/jxl" "$IMAGE_VIEWER"
    handlr set "image/png" "$IMAGE_VIEWER"
    handlr set "image/svg+xml" "$IMAGE_VIEWER"
    handlr set "image/tiff" "$IMAGE_VIEWER"
    handlr set "image/webp" "$IMAGE_VIEWER"
    handlr set "image/x-adobe-dng" "$IMAGE_VIEWER"

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
