#!/bin/sh

set -eu

scriptdir="$(cd -- "$(dirname -- "$0")" && pwd -P)" >/dev/null 2>&1

check_cond() {
    if ! command -v ansible >/dev/null 2>&1; then
        echo "Error: ansible is not installed" >&2
        exit 1
    fi
}

main() {
    check_cond
    cd "$scriptdir" || exit
    exec ansible-playbook -i "inventory.ini" -- main.yaml
}

main
