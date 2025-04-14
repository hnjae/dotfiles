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
    #!/bin/sh

    set -eu

    if git diff --cached --quiet --exit-code; then
        echo "Nothing to commit."
        exit 0
    fi

    echo ""
    git -c color.ui=always diff --staged --compact-summary
    echo ""

    echo "> commit? [y/Any]: " > /dev/stderr

    stty -icanon -echo
    eval "response=$(dd bs=1 count=1 2>/dev/null)"
    stty icanon echo

    echo ""

    case "$response" in
    "y") ;; # catch
    *)
            echo "O.k., not committing."
            exit 0
            ;;
    esac

    git commit --no-verify -m '{{ hostname }}: {{ datetime("%Y-%m-%dT%H:%M:%S%Z") }}'

sync:
    #!/bin/sh

    set -eu

    git add --all

    echo ""
    git -c color.ui=always status --short --untracked-files=all --find-renames=y
    echo ""

    echo "> sync? [Y/Any]: " > /dev/stderr

    stty -icanon -echo
    eval "response=$(dd bs=1 count=1 2>/dev/null)"
    stty icanon echo

    echo ""

    case "$response" in
    "Y") ;; # catch
    *)
            echo "O.k., not syncing."
            exit 0
            ;;
    esac

    git commit --no-verify -m '{{ hostname }}: {{ datetime("%Y-%m-%dT%H:%M:%S%Z") }}'
    git push
