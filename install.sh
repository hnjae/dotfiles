#!/usr/bin/env bash

set -euo pipefail

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

check_cond() {
  if ! command -v python3 >/dev/null 2>&1; then
    echo "ERROR: python3 is not installed on your system" >&2
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
  local dotbot_bin_abs="${scriptdir}/${dotbot_dir}/${dotbot_bin}"

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
  local profile_dir="$scriptdir/profiles/$profile"

  echo "INFO: Running dotbot with profile: $profile" >&2
  "$dotbot_cmd" -d "$profile_dir" -c "${profile_dir}/${CONFIG}"
}

main() {
  check_cond

  dotbot_cmd="$(get_dotbot)"
  local hostname_
  hostname_="$(hostname)"
  # local uname_
  # uname_="$(uname)"

  cd "$scriptdir"

  install_profile "00-default"

  case "$hostname_" in
  osiris | isis)
    install_profile "40-linux-desktop"
    install_profile "40-kde"
    install_profile "80-home-desktop"
    ANSIBLE_HOST_TYPE="home" "${scriptdir}/ansible/run.sh"
    ;;
  *)
    "${scriptdir}/ansible/run.sh"
    ;;
  esac
}

main "${@}"
