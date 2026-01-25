#!/bin/sh

set -eu

XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"
script_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)" >/dev/null 2>&1

check_cond() {
    if ! command -v python3 >/dev/null 2>&1; then
        echo "ERROR: python3 is not installed on your system" >&2
        exit 1
    fi
}

get_dotbot() {
    _dotbot_dir=".lib/dotbot"
    _dotbot_bin="bin/dotbot"
    _dotbot_bin_abs="${script_dir}/${_dotbot_dir}/${_dotbot_bin}"

    if [ ! -x "$_dotbot_bin_abs" ]; then
        echo "INFO: dotbot module not found, initializing submodules" >&2

        # submodule reset & clean
        git submodule foreach --recursive 'git reset --hard && git clean -fd'
        git submodule sync --quiet --recursive  # URL Update
        git submodule update --init --recursive # 실제 코드 가져오기
    fi

    echo "$_dotbot_bin_abs"
}

install_profile() {
    _profile="$1"
    _configfile="install.conf.yaml"
    _profile_dir="$script_dir/profiles/$_profile"

    echo "INFO: Running dotbot with profile: $_profile" >&2
    "$dotbot_cmd" -d "$_profile_dir" -c "${_profile_dir}/${_configfile}"
}

main() {
    check_cond

    dotbot_cmd="$(get_dotbot)"
    _hostname="$(uname --nodename)"

    cd "$script_dir"

    install_profile "00-default"

    case "$_hostname" in
    osiris | hemera)
        install_profile "40-linux-desktop"
        install_profile "40-kde"
        install_profile "80-home-desktop"
        if [ "${SKIP_ANSIBLE:-}" = "" ]; then
            ANSIBLE_HOST_TYPE="home" "${script_dir}/ansible/run.sh"
        fi
        ;;
    *)
        if [ "${SKIP_ANSIBLE:-}" = "" ]; then
            "${script_dir}/ansible/run.sh"
        fi
        ;;
    esac
}

main "${@}"
