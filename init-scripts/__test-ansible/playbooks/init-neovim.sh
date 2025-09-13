#!/bin/sh

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

LAZYNVIM_MARKER_FILE="${XDG_STATE_HOME}/nvim/lazy-nvim-initialized"

is_internet_connected() {
  if [ "${_internet_connected_cache+x}" != "" ]; then
    return "$_internet_connected_cache"
  fi

  if ping -c 1 1.1.1.1 >/dev/null 2>&1; then
    _internet_connected_cache=0 # connected
  else
    _internet_connected_cache=1
  fi

  return "$_internet_connected_cache"
}

# Arguments:
#   $1: Full path to the file/directory
backup_path() {
  target_path="$2"

  if [ ! -e "$target_path" ]; then
    return
  fi

  backup_path_="${target_path}.backup.$(date --utc '+%Y%m%dT%H%M%S%Z')"
  echo "Existing file/directory found at ${target_path}. Backing up to ${backup_path_}." >&2

  if ! mv -n "$target_path" "$backup_path_"; then
    echo "Failed to move existing file/directory to backup location." >&2
    return 1
  fi
}

check_cond() {
  if ! command -v nvim >/dev/null 2>&1; then
    echo "Error: nvim is not installed" >&2
    exit 0
  fi

  if ! is_internet_connected; then
    echo "Error: Internet is not connected" >&2
  fi
}

main() {
  check_cond

  if [ ! -f "$LAZYNVIM_MARKER_FILE" ]; then
    echo "Initializing lazy.nvim"
    backup_path "${XDG_STATE_HOME}/nvim"
    backup_path "${XDG_DATA_HOME}/nvim"
    nvim --headless -c "autocmd User VeryLazy ++once Lazy install" -c "qa"
    mkdir -p "${XDG_STATE_HOME}/nvim" && touch "$LAZYNVIM_MARKER_FILE"
  fi

  echo "Initializing copilot.nvim"
  # TODO: make this work <2025-09-11>
  nvim --headless -c "autocmd User VeryLazy ++once Copilot auth" -c "qa"

  # TODO: install mason headlessly <2025-08-11>
}

main
