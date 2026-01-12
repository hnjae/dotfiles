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
    # Creates tinted-theming/my-templates/tinted-*/themes/base24-*

    set -euo pipefail

    XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

    templates="${XDG_CONFIG_HOME}/tinted-theming/my-templates"
    myschemes="${XDG_CONFIG_HOME}/tinted-theming/my-schemes"

    if [ ! -d "$templates" ] || [ ! -d "$myschemes" ]; then
        echo "ERROR: $templates or $myschemes is not installed" >&2
        exit 1
    fi

    for template in "$templates"/*; do
        .lib/tinted-builder-rust/bin/tinted-builder-rust build -s "$myschemes" "$template"
    done

# NOTE: this recipe is broken due to tinty update
update-tinted:
    #!/bin/sh

    set -eu

    XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

    templates="${XDG_CONFIG_HOME}/tinted-theming/my-templates"
    myschemes="${XDG_CONFIG_HOME}/tinted-theming/my-schemes"

    if [ ! -d "$templates" ] || [ ! -d "$myschemes" ]; then
        echo "ERROR: $templates or $myschemes is not installed" >&2
        exit 1
    fi

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

update-submodules:
    .lib/update-submodules.sh

# NOTE: 아래는 lazy-lock.json 과 sync 를 하는게 아니라 업데이트하는 명령임.
# nvim --headless -c "autocmd User VeryLazy ++once Lazy! sync" -c "qa"

nvim-sync-frozen:
    nvim --headless -c 'autocmd User VeryLazy ++once lua require("lazy").restore({wait=true}) vim.cmd("qall")'

GIT-FCITX5-PROFILE:
    git update-index --skip-worktree "profiles/40-linux-desktop/xdg-config/fcitx5/profile"
