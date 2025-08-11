#!/usr/bin/env bash

set -euf

CONFIG="install.conf.yaml"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

main() {
  check_cond
  dotbot_cmd="$(get_dotbot)"

  cd "$BASE_DIR"
  "$dotbot_cmd" -d "$BASE_DIR" -c "$CONFIG" "${@}"

  local hostname_
  hostname_="$(hostname)"

  if [ "$hostname_" = "osiris" ] || [ "$hostname_" = "isis" ]; then
    local profile_dir="$BASE_DIR/profiles.desktop"

    cd "$profile_dir"
    "$dotbot_cmd" -d "$profile_dir" -c "${profile_dir}/${CONFIG}" "${@}"
  fi

  # Bootstrap
  marker_file="${XDG_STATE_HOME}/dotfiles-bootstrapped"
  if [[ ! -e "$marker_file" || "$marker_file" -ot "$BASE_DIR/bootstrap.sh" ]]; then
    "$BASE_DIR/bootstrap.sh"
  fi
}

main "${@}"
