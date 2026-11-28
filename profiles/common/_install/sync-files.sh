#!/bin/sh

# SPDX-License-Identifier: AGPL-3.0-or-later
# SPDX-FileCopyrightText: 2026 KIM Hyunjae

# Reconcile every `<anchor>[+<subpath>]@sync` source into its live path.
# The repository copy wins when content or mode differs; target-only files
# (runtime state) are never removed. `xdg-bin-home` files are executable
# (0755); every other synced file is owner-only (0600). Directories created
# below an anchor are 0700, while anchor roots keep their existing mode.
#
# Anchors resolve to the fixed defaults used by install.conf.yaml. The
# dotfiles repository does not honor XDG environment overrides.

set -eu

: "${HOME:?HOME is not set}"

script_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)" >/dev/null 2>&1
profile_dir="$(dirname "$script_dir")"
cd "$profile_dir"

umask 077

list_file=
tmp_file=
changed=0

cleanup() {
    if [ "$list_file" != "" ]; then
        rm -f "$list_file"
    fi
    if [ "$tmp_file" != "" ]; then
        rm -f "$tmp_file"
    fi
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM

die() {
    printf 'ERROR: %s\n' "$*" >&2
    exit 1
}

anchor_root() {
    case "$1" in
    home) printf '%s\n' "$HOME" ;;
    xdg-config-home) printf '%s\n' "$HOME/.config" ;;
    xdg-data-home) printf '%s\n' "$HOME/.local/share" ;;
    xdg-bin-home) printf '%s\n' "$HOME/.local/bin" ;;
    *) return 1 ;;
    esac
}

file_mode() {
    if [ "$1" = "xdg-bin-home" ]; then
        printf '755\n'
    else
        printf '600\n'
    fi
}

sync_file() {
    src=$1
    dst=$2
    anchor=$3
    root_dir=$4
    mode=$(file_mode "$anchor")
    target_dir=$(dirname "$dst")

    if [ -L "$target_dir" ]; then
        die "refusing to write through symlink directory: $target_dir"
    fi
    if [ -e "$target_dir" ] && [ ! -d "$target_dir" ]; then
        die "target is not a directory: $target_dir"
    fi
    if [ -d "$dst" ]; then
        die "refusing to replace a directory: $dst"
    fi

    if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
    fi
    if [ "$target_dir" != "$root_dir" ] &&
        [ "$(stat -c '%a' "$target_dir")" != "700" ]; then
        chmod 700 "$target_dir"
        changed=$((changed + 1))
        printf 'INFO: secured %s\n' "$target_dir" >&2
    fi

    if [ -f "$dst" ] && [ ! -L "$dst" ] &&
        [ "$(stat -c '%a' "$dst")" = "$mode" ] &&
        [ "$(stat -c '%h' "$dst")" = "1" ] &&
        cmp -s "$src" "$dst"; then
        return 0
    fi

    if [ -f "$dst" ] && [ ! -L "$dst" ] &&
        [ "$(stat -c '%h' "$dst")" = "1" ] &&
        cmp -s "$src" "$dst"; then
        chmod "$mode" "$dst"
        changed=$((changed + 1))
        printf 'INFO: mode %s %s\n' "$mode" "$dst" >&2
        return 0
    fi

    tmp_file=$(mktemp "$target_dir/.sync.XXXXXX")
    cp "$src" "$tmp_file"
    chmod "$mode" "$tmp_file"
    mv -f "$tmp_file" "$dst"
    tmp_file=
    changed=$((changed + 1))
    printf 'INFO: synced %s\n' "$dst" >&2
}

for src_root in ./*@sync; do
    [ -d "$src_root" ] || continue
    src_root=${src_root#./}
    name=${src_root%@sync}
    anchor=${name%%+*}
    root=$(anchor_root "$anchor") || die "unknown @sync anchor: $src_root"

    subpath=${name#"$anchor"}
    subpath=${subpath#+}
    if [ "$subpath" != "" ]; then
        subpath=$(printf '%s' "$subpath" | tr '+' '/')
        target_root=$root/$subpath
    else
        target_root=$root
    fi

    invalid=$(find "$src_root" -mindepth 1 ! -type d ! -type f -print -quit)
    if [ "$invalid" != "" ]; then
        die "unsupported non-regular source: $invalid"
    fi

    list_file=$(mktemp)
    find "$src_root" -type f -print >"$list_file"
    while IFS= read -r src; do
        rel=${src#"$src_root"/}
        sync_file "$src" "$target_root/$rel" "$anchor" "$root"
    done <"$list_file"
    rm -f "$list_file"
    list_file=
done

if [ "$changed" -eq 0 ]; then
    printf 'INFO: @sync files are unchanged\n' >&2
fi
