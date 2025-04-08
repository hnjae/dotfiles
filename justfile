#!/usr/bin/env -S just --justfile

hostname := `hostname`

_:
    @just --list

stow:
    #!/bin/sh

    CONFIG_NAME="nvim"
    scriptDir="$(cd -- "$(dirname -- "")" && pwd -P)" >/dev/null 2>&1
    XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

    [ ! -d "${scriptDir}/${CONFIG_NAME}" ] && echo "${scriptDir}/${CONFIG_NAME} does not exists." && exit 1
    [ ! -d "$XDG_CONFIG_HOME" ] && mkdir -p "$XDG_CONFIG_HOME"

    [ -h "${XDG_CONFIG_HOME}/${CONFIG_NAME}" ] && rm "${XDG_CONFIG_HOME}/${CONFIG_NAME}" && echo "rm previous symlinks"
    [ -d "${XDG_CONFIG_HOME}/${CONFIG_NAME}" ] && echo "Erase ${XDG_CONFIG_HOME}/${CONFIG_NAME} to continue." && exit 1

    ln -v -s "${scriptDir}/${CONFIG_NAME}" "${XDG_CONFIG_HOME}/${CONFIG_NAME}"

commit:
    git add --all
    git commit --no-verify -m '{{ hostname }}: {{ datetime("%Y-%m-%dT%H:%M:%S%Z") }}'
