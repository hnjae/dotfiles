# shellcheck shell=sh
# NOTE: `zsh` 설정에서 source 하도록 설정해야 함.

if [ "$__DOT_PROFILE_SOURCED" != "" ]; then return; fi
export __DOT_PROFILE_SOURCED=1

# NOTE:
# https://specifications.freedesktop.org/basedir/latest/
# https://gist.github.com/roalcantara/107ba66dfa3b9d023ac9329e639bc58c
export XDG_BIN_HOME="${XDG_BIN_HOME:-${HOME}/.local/bin}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

export EDITOR="nvim"
export VISUAL="nvim"

export IPYTHONDIR="${XDG_STATE_HOME}/ipython"
export PYTHON_COLORS="1"
export PYTHON_HISTORY="${XDG_STATE_HOME}/python_history"

# XDG Base Directory Specification 에 맞춰 정리할 수 없는 것들:

# https://github.com/rust-lang/cargo/issues/1734#issuecomment-2607411878
# https://blog.rust-lang.org/inside-rust/2025/10/01/this-development-cycle-in-cargo-1.90/#all-hands-xdg-paths

export CARGO_HOME="${XDG_DATA_HOME}/cargo"   # default: $HOME/.cargo
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup" # default: $HOME/.rustup

# GO
export GOPATH="${XDG_DATA_HOME}/go"              # default: $HOME/go
export GOMODCACHE="${XDG_CACHE_HOME}/go/pkg_mod" # default: $GOPATH/pkg/mod
export GOTELEMETRY="off"
export GOTELEMETRYDIR="${XDG_STATE_HOME}/go/telemetry" # default: $HOME/.config/go/telemetry

# Nodejs
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npmrc"
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME}/npm"

# Bun
# https://bun.com/docs/runtime/environment-variables
# export DO_NOT_TRACK=1
# if [ -d "${XDG_CACHE_HOME}/.bun/bin" ]; then
#     export PATH="${XDG_CACHE_HOME}/.bun/bin:$PATH"
# fi
