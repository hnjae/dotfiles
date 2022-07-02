#!/usr/bin/env sh

type fd > /dev/null || echo "fd not installed" || exit 1

# TODO: make this as systemd timer  <2022-06-25, Hyunjae Kim>

XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
fd . \
    -H \
    -I \
    --changed-before 3weeks \
    -t file "$XDG_CACHE_HOME" \
    --exec rm -rf > /dev/null 2>&1
# TODO: run below until no empty directory <2022-06-30, Hyunjae Kim>
fd . -H -I -t d -t empty "$XDG_CACHE_HOME" --exec rmdir > /dev/null 2>&1
