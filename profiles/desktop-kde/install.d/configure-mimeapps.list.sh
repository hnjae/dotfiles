#!/bin/sh

set -eu

BROWSER="com.brave.Browser.desktop"

main() {
    handlr set 'video/mpv' io.mpv.Mpv.desktop
    handlr set 'video/x-ms-wmv' io.mpv.Mpv.desktop
    handlr set "video/x-ms-asf" io.mpv.Mpv.desktop

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
