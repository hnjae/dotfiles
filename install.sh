#!/usr/bin/env bash

set -euf

CONFIG="install.conf.yaml"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if command -v dotbot >/dev/null 2>&1; then
  dotbot -d "$BASE_DIR" -c "$CONFIG" "${@}"
elif command -v nix >/dev/null 2>&1; then
  nix run 'nixpkgs#dotbot' -- -d "$BASE_DIR" -c "$CONFIG" "${@}"
else
  if ! command -v python3 >/dev/null 2>&1; then
    echo "[ERROR] python3 is not installed on your system" >/dev/stderr
    exit 1
  fi

  DOTBOT_DIR=".submodules/dotbot"
  DOTBOT_BIN="bin/dotbot"
  cd "$BASE_DIR"

  if [ ! -f "$DOTBOT_DIR" ]; then
    git -C "$DOTBOT_DIR" submodule sync --quiet --recursive
  fi

  "${BASE_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "$BASE_DIR" -c "$CONFIG" "${@}"
fi
