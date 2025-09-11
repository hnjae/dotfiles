#!/bin/sh

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

scriptdir="$(cd -- "$(dirname -- "$0")" && pwd -P)" >/dev/null 2>&1

check_cond() {
  if ! command -v sudo >/dev/null 2>&1; then
    echo "Error: sudo is not installed" >&2
    exit 1
  fi
}

main() {
  check_cond
  exec sudo "${scriptdir}/assets/init-profile-pictures.py"
}

main
