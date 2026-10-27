#!/bin/sh

set -eu

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

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

if ! command -v nvim >/dev/null 2>&1; then
    echo "INFO: neovim is not installed" >&2
    exit 0
fi

lockfile="$XDG_CONFIG_HOME/nvim/lazy-lock.json"
lazy_dir="$XDG_DATA_HOME/nvim/lazy"
state_dir="$XDG_STATE_HOME/dotfiles"
state_file="$state_dir/nvim-lazy-lock.hash"

current_hash=""
if [ -f "$lockfile" ]; then
    current_hash="$(hash_file "$lockfile")"
else
    echo "INFO: lazy-lock.json is missing; running lazy restore" >&2
fi

if [ "${DOTFILES_FORCE_NVIM_RESTORE:-0}" != "1" ] &&
    [ "$current_hash" != "" ] &&
    [ -d "$lazy_dir" ] &&
    [ -f "$state_file" ] &&
    [ "$(cat "$state_file")" = "$current_hash" ]; then
    echo "INFO: lazy-lock.json is unchanged; skipping lazy restore" >&2
    exit 0
fi

echo "INFO: Restore plugin status to lazy-lock.json" >&2

nvim --headless -c "$(
    cat <<'EOF'
lua
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function ()
      require("lazy").restore({wait=true, concurrency=4})
      vim.cmd("qall")
    end,
  })
EOF
)"

if [ -f "$lockfile" ]; then
    mkdir -p "$state_dir"
    hash_file "$lockfile" >"$state_file"
fi
