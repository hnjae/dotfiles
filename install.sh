#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

check_cond() {
  if ! command -v python3 >/dev/null 2>&1; then
    echo "[ERROR] python3 is not installed on your system" >&2
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
    git -C "$dotbot_dir" submodule sync --quiet --recursive >&2
    # dotbot 의 submodule url 업데이트.
  fi

  echo "$dotbot_bin_abs"
}

install_profile() {
  CONFIG="install.conf.yaml"

  local profile="$1"
  local profile_dir="$BASE_DIR/profiles/$profile"

  echo "[INFO] Running dotbot with profile: $profile" >&2
  "$dotbot_cmd" -d "$profile_dir" -c "${profile_dir}/${CONFIG}"
}

run_inits() {
  target="${BASE_DIR}/init-scripts/$1"

  if [ "$1" = "" ]; then
    printf "[ERROR] run_inits: Argument not provided" >&2
    return 1
  fi

  if [ ! -d "$target" ]; then
    printf "[ERROR] Directory '%s' does not exist.\n" "$target" >&2
    return 1
  fi

  ret=0
  shopt -s nullglob
  for script in "$target"/init-*; do
    if [ ! -x "$script" ] || [ ! -f "$script" ]; then
      printf "[WARN] %s is not executable file\n" "$script" >&2
      continue
    fi

    printf "[INFO] Executing: %s\n" "$script" >&2
    "$script"

    script_exit_code="$?"
    if [ "$script_exit_code" -ne 0 ]; then
      ret=1
      printf "[WARN] Script '%s' exited with code %d\n" "$script" "$script_exit_code" >&2
    fi
  done
  shopt -u nullglob

  return "$ret"
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
  run_inits "default"

  case "$hostname_" in
  osiris | isis)
    install_profile "40-linux-desktop"
    install_profile "40-kde"
    install_profile "80-home-desktop"
    install_profile "80-home-linux"
    run_inits "linux-desktop"
    run_inits "home-linux-desktop"
    ;;
  eris)
    install_profile "80-home-linux"
    ;;
  *) ;;
  esac
}

main "${@}"
