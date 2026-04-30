#!/bin/sh

set -eu

seed_dir() {
  src_root="$1"
  dst_root="$2"

  [ -d "$src_root" ] || return 0

  find "$src_root" -type f | while IFS= read -r src; do
    rel="${src#"$src_root"/}"
    dst="$dst_root/$rel"

    [ -e "$dst" ] && continue

    dst_parent="$(dirname "$dst")"

    if [ ! -d "$dst_parent" ]; then
      if [ -e "$dst_parent" ] || [ -h "$dst_parent" ]; then
        mv --no-clobber "$dst_parent" "${dst_parent}.backup.$(date --utc -- '+%Y%m%dT%H%M%SZ')"
      fi

      mkdir -p "$dst_parent"
    fi

    cp --no-clobber "$src" "$dst"
  done
}

main() {
  seed_dir "xdg-config-home@seed" "$HOME/.config"
}

main "$@"
