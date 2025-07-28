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
    # Create ./_xdg.config-files/tinted-theming/my-templates/tinted-*/themes/base24-*

    set -euo pipefail

    # WIP: add tinted-builder-rust using nix. This is a temporary impure solution.
    PATH="~/.local/state/cargo/bin:$PATH"

    templates="./tinted/my-templates"
    myschemes="./tinted/custom-schemes"
    # schemes="./_xdg.data-files/tinted-theming/tinty/repos/schemes/base24"
    for template in "$templates"/*; do
        tinted-builder-rust build -s "$myschemes" "$template"
        # [ -d "$schemes" ] &&  tinted-builder-rust build -s "$schemes" "$template"
    done

update-tinted: build-tinted
    #!/bin/sh

    set -eu

    # theme="base24-my-gruvbox-light"
    # theme="base24-my-kanagawa-dragon"
    # theme="base24-my-rose-pine"
    theme="base24-my-kanagawa-wave"

    if command -v tinty >/dev/null 2>&1; then
        tinty sync
        tinty apply "$theme"
    elif command -v nix >/dev/null 2>&1; then
        nix run 'nixpkgs#tinty' -- sync
        nix run 'nixpkgs#tinty' -- apply "$theme"
    else
        echo "Error: Neither tinty nor nix found in PATH" >/dev/stderr
        exit 1
    fi
