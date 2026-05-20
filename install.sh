#!/bin/sh

set -eu

XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"
script_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)" >/dev/null 2>&1

# POSIX sh compatible logger

_log_init() {
    if [ "${LOG_SYSTEMD:-}" = "1" ]; then
        _log_systemd=1
    elif [ "${LOG_SYSTEMD:-}" = "0" ]; then
        _log_systemd=0
    elif [ "${JOURNAL_STREAM:-}" != "" ] || [ "${INVOCATION_ID:-}" != "" ]; then
        _log_systemd=1
    else
        _log_systemd=0
    fi

    if [ "$_log_systemd" = "1" ] || [ ! -t 2 ] || [ "${NO_COLOR:-}" != "" ]; then
        _log_color_reset=''
        _log_color_bright_black=''
        _log_color_red=''
        _log_color_yellow=''
        _log_color_blue=''
        _log_color_cyan=''
    else
        _log_esc=$(printf '\033')
        _log_color_reset="${_log_esc}[0m"
        _log_color_bright_black="${_log_esc}[90m"
        _log_color_red="${_log_esc}[31m"
        _log_color_yellow="${_log_esc}[33m"
        _log_color_blue="${_log_esc}[34m"
        _log_color_cyan="${_log_esc}[36m"
    fi
}

_log_init

log() {
    _log_severity="${1:-UNKNOWN}"

    if [ "$#" -gt 0 ]; then
        shift
    fi

    _log_message=$*

    case "$_log_severity" in
    ERR)
        _log_priority=3
        _log_severity_color=$_log_color_red
        ;;
    WARNING)
        _log_priority=4
        _log_severity_color=$_log_color_yellow
        ;;
    NOTICE)
        _log_priority=5
        _log_severity_color=$_log_color_cyan
        ;;
    INFO)
        _log_priority=6
        _log_severity_color=$_log_color_blue
        ;;
    DEBUG)
        _log_priority=7
        _log_severity_color=$_log_color_bright_black
        ;;
    *)
        _log_priority=6
        _log_severity="UNKNOWN"
        _log_severity_color=$_log_color_reset
        ;;
    esac

    if [ "$_log_systemd" = "1" ]; then
        printf '<%s>%s: %s\n' \
            "$_log_priority" \
            "$_log_severity" \
            "$_log_message" >&2
        return
    fi

    _log_timestamp=$(date '+%Y-%m-%dT%H:%M:%S%z')

    printf '%s[%s]%s %s%s%s: %s\n' \
        "$_log_color_bright_black" \
        "$_log_timestamp" \
        "$_log_color_reset" \
        "$_log_severity_color" \
        "$_log_severity" \
        "$_log_color_reset" \
        "$_log_message" >&2
}

check_cond() {
    if ! command -v python3 >/dev/null 2>&1; then
        log ERR "python3 is not installed on your system"
        exit 1
    fi
}

get_dotbot() {
    _dotbot_dir="lib/dotbot"
    _dotbot_bin="bin/dotbot"
    _dotbot_bin_abs="${script_dir}/${_dotbot_dir}/${_dotbot_bin}"

    if [ ! -x "$_dotbot_bin_abs" ]; then
        log "INFO" "dotbot module not found, initializing submodules"

        # submodule reset & clean
        git submodule foreach --recursive 'git reset --hard && git clean -fd'
        git submodule sync --quiet --recursive  # URL Update
        git submodule update --init --recursive # 실제 코드 가져오기
    fi

    printf '%s' "$_dotbot_bin_abs"
}

install_profile() {
    _profile="$1"
    _configfile="install.conf.yaml"
    _profile_dir="$script_dir/profiles/$_profile"

    log INFO "Running dotbot with profile: $_profile"
    "$dotbot_cmd" --base-directory "$_profile_dir" --config-file "${_profile_dir}/${_configfile}"
}

main() {
    check_cond

    cd "$script_dir"

    dotbot_cmd="$(get_dotbot)"
    _hostname="$(uname --nodename)"

    install_profile "common"

    case "$_hostname" in
    hemera | nyx)
        install_profile "desktop"

        # Install others:
        install_profile "desktop-linux"
        install_profile "desktop-kde"

        git update-index --skip-worktree "profiles/desktop-kde/xdg-config-home/kactivitymanagerdrc" 2>/dev/null || true
        git update-index --skip-worktree 'profiles/desktop-kde/xdg-config-home/fcitx5/profile' 2>/dev/null || true
        git update-index --skip-worktree 'profiles/desktop-kde/xdg-config-home/fcitx5/conf/hangul.conf' 2>/dev/null || true
        ;;
    esac
}

main "${@}"
