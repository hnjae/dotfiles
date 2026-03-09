#!/bin/sh

set -eu

scrip_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)" >/dev/null 2>&1

check_cond() {
    if ! command -v ansible >/dev/null 2>&1; then
        echo "ERROR: ansible is not installed" >&2
        exit 1
    fi
}

main() {
    echo "INFO: Running ansible" >&2
    check_cond

    cd "$scrip_dir" || exit
    exec ansible-playbook -i "inventory.ini" -- main.yaml
}

main
