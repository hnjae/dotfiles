#!/usr/bin/env bash

set -euf

CONFIG="install.conf.yaml"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

check_cond() {
  if ! command -v python3 >/dev/null 2>&1; then
    echo "[ERROR] python3 is not installed on your system" >/dev/stderr
    exit 1
  fi
}

get_dotbot() {
  if command -v dotbot >/dev/null 2>&1; then
    echo "dotbot"
    return
  fi

  local dotbot_dir=".lib/dotbot"
  local dotbot_bin="bin/dotbot"
  local dotbot_bin_abs="${BASE_DIR}/${dotbot_dir}/${dotbot_bin}"

  if [ ! -x "$dotbot_bin_abs" ]; then
    git submodule sync --quiet --recursive  # URL Update
    git submodule update --init --recursive # 실제 코드 가져오기

    git -C "$dotbot_dir" submodule sync --quiet --recursive >/dev/stderr
  fi

  echo "$dotbot_bin_abs"
}

install_profile() {
  local profile="$1"
  local profile_dir="$BASE_DIR/profiles.$profile"

  echo "[INFO] Running dotbot with profile: $profile" >/dev/stderr
  "$dotbot_cmd" -d "$profile_dir" -c "${profile_dir}/${CONFIG}"
}

main() {
  check_cond
  dotbot_cmd="$(get_dotbot)"

  cd "$BASE_DIR"

  echo "[INFO] Running dotbot" >/dev/stderr
  "$dotbot_cmd" -d "$BASE_DIR" -c "$CONFIG" "${@}"

  local hostname_
  hostname_="$(hostname)"
  local uname_
  uname_="$(uname)"

  local profile_dir
  if [ "$uname_" = "Linux" ] && [ "$HOME" = "/home/hnjae" ]; then
    install_profile "home-linux"
  fi

  if [ "$hostname_" = "osiris" ] || [ "$hostname_" = "isis" ]; then
    install_profile "home-desktop"
    install_profile "linux-desktop"
    install_profile "kde"
  fi

  # Bootstrap
  marker_file="${XDG_STATE_HOME}/dotfiles-bootstrapped"
  if [[ ! -e "$marker_file" || "$marker_file" -ot "$BASE_DIR/bootstrap.sh" ]]; then
    echo "[INFO] RUNNING bootstrap.sh" >/dev/stderr
    "$BASE_DIR/bootstrap.sh"
  fi
}

main "${@}"
