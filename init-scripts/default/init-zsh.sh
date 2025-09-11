#!/bin/sh

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

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

check_cond() {
  if ! command -v zsh >/dev/null 2>&1; then
    echo "Error: zsh is not installed" >&2
    exit 1
  fi

  if ! is_internet_connected; then
    echo "Error: Internet is not connected" >&2
  fi
}

main() {
  check_cond

  # Check zimfw / dotbot 으로 이미 zimfw 가 설치되어야 함.
  if [ ! -f "${XDG_DATA_HOME}/zimfw/init.zsh" ]; then
    git submodule sync --quiet --recursive
    git submodule update --init --recursive
  fi

  echo "Initializing zimfw" >&2
  TERM=dumb exec zsh --interactive -c '
      if ! command -v zimfw >/dev/null 2>&1; then
        return
      fi

      zimfw init
    '
}

main
