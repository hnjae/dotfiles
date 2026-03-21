#!/usr/bin/env -S just --justfile

alias fmt := format
alias lint := check

hostname := `hostname`

_:
    @just --list

install-all:
    ./install.sh

install-dotfiles:
    SKIP_ANSIBLE=1 ./install.sh

[group('ci')]
format:
    prek run --hook-stage pre-commit --all-files

[group('ci')]
check:
    prek run --hook-stage pre-merge-commit --all-files

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

update-tinted:
    #!/bin/sh

    set -eu

    theme="base24-my-kanagawa-wave"

    if command -v tinty >/dev/null 2>&1; then
        tinty sync
        tinty apply "$theme"
    elif command -v nix >/dev/null 2>&1; then
        nix run 'nixpkgs#tinty' -- sync
        nix run 'nixpkgs#tinty' -- apply "$theme"
    else
        echo "ERR: Neither tinty nor nix found in PATH" >/dev/stderr
        exit 1
    fi

update-submodules:
    .lib/update-submodules.sh

# nvim --headless -c 'autocmd User VeryLazy ++once lua require("lazy").restore({wait=true}) vim.cmd("qall")'

[group('nvim')]
nvim-plugin-restore:
    .lib/nvim-plugin-restore.sh

[group('nvim')]
nvim-plugin-sync:
    .lib/nvim-plugin-sync.sh
    git reset
    git add -- profiles/00-default/xdg-config/nvim/lazy-lock.json
    git commit -m "build(nvim): update lazy-lock.json"
