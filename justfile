#!/usr/bin/env -S just --justfile

hostname := `hostname`

_:
    @just --list

install:
    ./install.sh

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

    echo "> sync? [y/Any]: " > /dev/stderr

    stty -icanon -echo
    eval "response=$(dd bs=1 count=1 2>/dev/null)"
    stty icanon echo

    echo ""

    case "$response" in
    "y") ;; # catch
    *)
            echo "O.k., not syncing."
            exit 0
            ;;
    esac

    git commit --no-verify -m '{{ hostname }}: {{ datetime("%Y-%m-%dT%H:%M:%S%Z") }}'
    git push

build-tinted:
    #!/usr/bin/env bash

    # WIP: add tinted-builder-rust using nix. This is a temporary solution.
    PATH="~/.local/state/cargo/bin:$PATH"

    templates="./_xdg.config-files/tinted-theming/my-templates"
    schemes="./_xdg.data-files/tinted-theming/tinty/custom-schemes"
    for template in "$templates"/*; do
        tinted-builder-rust build -s "$schemes" "$template"
    done

update-tinted:
    #!/usr/bin/env bash

    if hash tinty 2>/dev/null; then
        tinty sync
        tinty apply base24-my-gruvbox-light
        # tinty apply base24-my-selenized-light
    fi
