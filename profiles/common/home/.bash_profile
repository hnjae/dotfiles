# shellcheck shell=bash

if [[ $- == *i* && -s "${HOME}/.bashrc" ]]; then
    # shellcheck source=/dev/null
    . "${HOME}/.bashrc"
fi
