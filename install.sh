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

# TODO: clone git submodule if zimfw doesnot exists <2025-08-25>

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

    git -C "$dotbot_dir" submodule sync --quiet --recursive >/dev/stderr # DO I need this?
  fi

  echo "$dotbot_bin_abs"
}

install_profile() {
  local profile="$1"
  local profile_dir="$BASE_DIR/profiles/$profile"

  echo "[INFO] Running dotbot with profile: $profile" >/dev/stderr
  "$dotbot_cmd" -d "$profile_dir" -c "${profile_dir}/${CONFIG}"
}

main() {
  check_cond
  dotbot_cmd="$(get_dotbot)"
  local hostname_
  hostname_="$(hostname)"
  # local uname_
  # uname_="$(uname)"

  cd "$BASE_DIR"

  install_profile "00-default"

  case "$hostname_" in
  osiris | isis)
    install_profile "40-linux-desktop"
    install_profile "40-kde"
    install_profile "80-home-desktop"
    install_profile "80-home-linux"
    ;;
  eris)
    install_profile "80-home-linux"
    ;;
  *) ;;
  esac

  # Bootstrap
  marker_file="${XDG_STATE_HOME}/dotfiles-bootstrapped"
  if [[ ! -e "$marker_file" || "$marker_file" -ot "$BASE_DIR/bootstrap.sh" ]]; then
    echo "[INFO] RUNNING bootstrap.sh" >/dev/stderr
    "$BASE_DIR/bootstrap.sh"
  fi
}

main "${@}"
