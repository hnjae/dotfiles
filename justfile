#!/usr/bin/env -S just --justfile

alias fmt := format
alias lint := check

hostname := `hostname`

_:
    @just --list

[group('ci')]
format:
    prek run --hook-stage pre-commit --all-files

[group('ci')]
check:
    prek run --hook-stage pre-merge-commit --all-files

update-submodules:
    .lib/update-submodules.sh

sync-submodules:
    git submodule foreach --recursive 'git reset --hard && git clean -fd'
    git submodule sync --quiet --recursive  # URL Update
    git submodule update --init --recursive # 실제 코드 가져오기

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

[group('nvim')]
nvim-plugin-restore:
    .lib/nvim-plugin-restore.sh

[group('nvim')]
nvim-plugin-sync:
    .lib/nvim-plugin-sync.sh
    git reset
    git add -- profiles/00-default/xdg-config/nvim/lazy-lock.json
    git commit -m "build(nvim): update lazy-lock.json"
