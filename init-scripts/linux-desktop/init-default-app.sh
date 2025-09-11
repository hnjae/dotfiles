#!/bin/sh

check_cond() {
  if ! command -v xdg-settings >/dev/null 2>&1; then
    echo "Error: xdg-settings is not installed" >&2
    exit 1
  fi

  if ! command -v handlr >/dev/null 2>&1; then
    echo "Error: handlr is not installed" >&2
    exit 1
  fi
}

main() {
  check_cond

  echo "Configuring default applications" >&2

  xdg-settings set default-web-browser brave-desktop.desktop
  xdg-mime default 'org.kde.okular.desktop' 'applications/pdf'
  handlr set -- 'text/*' 'nvim.desktop'
  handlr set -- 'video/*' 'mpv.desktop'
  handlr set -- 'audio/*' 'mpv.desktop'

  return 0
}

main
