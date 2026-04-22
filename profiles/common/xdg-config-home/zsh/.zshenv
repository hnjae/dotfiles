# README:
#   이 파일은 $ZDOTDIR/.zshenv, $HOME/.zshenv 두 곳에 존재해야한다.
#   관찰 결과, 위 두 파일을 모두 읽는 경우는 없는 듯.
#   `login`, `interactive`, `script` 모든 zsh process 가 참조함.

# Do not source /etc/zshrc
typeset -g NOSYSZSHRC=1 # e.g. NixOS 의 zshrc 에서 기본 값으로 사용 <NixOS 25.11>

# if [[ "${__ETC_ZSHENV_SOURCED-}" != "" ]]; then
#     [[ -f "/etc/zsh/zshenv" ]] && source "/etc/zsh/zshenv" # e.g. Debian 13 (2026-04-22)
#     [[ -f "/etc/zshenv" ]] && source "/etc/zshenv"
# fi

if [[ "${__ZSHENV_SOURCED-}" != "" ]]; then return; fi
typeset -g __ZSHENV_SOURCED=1

# XDG Base Directory Specification
export XDG_BIN_DIR="${XDG_BIN_DIR:-${HOME}/.local/bin}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
