#!/bin/sh

set -eu

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

config_dir="$XDG_CONFIG_HOME/yazi"
package_file="$config_dir/package.toml"
state_dir="$XDG_STATE_HOME/dotfiles"
state_file="$state_dir/yazi-package.hash"

hash_file() {
    if command -v xxhsum >/dev/null 2>&1; then
        xxhsum "$1" | awk '{print $1}'
    elif command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$1" | awk '{print $1}'
    elif command -v shasum >/dev/null 2>&1; then
        shasum -a 256 "$1" | awk '{print $1}'
    else
        echo "ERROR: sha256sum or shasum is required" >&2
        exit 1
    fi
}

# Resolve the plugin directory yazi deploys for each `use = "owner/repo[:name]"`
# entry: the part after the colon, or the repository name, suffixed with `.yazi`.
plugin_names() {
    sed -n 's/^[[:space:]]*use[[:space:]]*=[[:space:]]*"\([^"]*\)".*/\1/p' "$package_file" |
        while IFS= read -r id; do
            name="${id##*:}"
            name="${name##*/}"
            printf '%s.yazi\n' "$name"
        done
}

# `ya pkg install` deletes every plugin directory it does not manage, which
# includes the tracked local-*.yazi plugins, and rewrites package.toml. Install
# in a scratch config directory instead, then deploy only the managed plugins.
install_into_scratch() {
    scratch_dir="$(mktemp -d)"
    trap 'rm -rf "$scratch_dir"' EXIT

    cp "$package_file" "$scratch_dir/package.toml"
    (cd "$scratch_dir" && YAZI_CONFIG_HOME="$scratch_dir" ya pkg install)

    mkdir -p "$config_dir/plugins"
    plugin_names | while IFS= read -r name; do
        rm -rf "${config_dir:?}/plugins/$name"
        cp -R "$scratch_dir/plugins/$name" "$config_dir/plugins/$name"
    done
}

if ! command -v ya >/dev/null 2>&1; then
    echo "INFO: ya is not installed" >&2
    exit 0
fi

if [ ! -f "$package_file" ]; then
    echo "INFO: $package_file is missing; skipping" >&2
    exit 0
fi

missing=""
for name in $(plugin_names); do
    if [ ! -d "$config_dir/plugins/$name" ]; then
        missing="$missing $name"
    fi
done

current_hash="$(hash_file "$package_file")"

if [ -z "$missing" ] &&
    [ -f "$state_file" ] &&
    [ "$(cat "$state_file")" = "$current_hash" ]; then
    echo "INFO: yazi plugins are unchanged; skipping" >&2
    exit 0
fi

if [ -n "$missing" ]; then
    echo "INFO: yazi plugins are missing:$missing" >&2
fi

echo "INFO: Installing yazi plugins" >&2

install_into_scratch

mkdir -p "$state_dir"
printf '%s\n' "$current_hash" >"$state_file"
