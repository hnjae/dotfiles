#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)" >/dev/null 2>&1

declare -A BRANCH_BASED_MODULES=(
    [profiles/desktop/xdg-config-home/mpv/script-repos/thumbfast]=1
    [profiles/desktop/xdg-config-home/mpv/script-repos/osc.lua]=1
    [profiles/desktop/xdg-config-home/mpv/script-repos/content-red-tester-s-scripts]=1
)

update_module_by_tag() {
    local module="$1"
    local latest_tag

    if [ ! -d "$module" ]; then
        echo "INFO: $module not found, initializing submodule" >&2
        # This will fetch main/master branch
        git submodule sync --quiet --recursive "$module" # URL Update
        git submodule update --init --recursive "$module"
    fi

    if ! git -C "$module" diff --quiet HEAD; then
        echo "INFO: Resetting local changes in $module" >&2
        git -C "$module" reset --hard HEAD
    fi

    if [ "$(git -C "$module" ls-files --others --exclude-standard)" != "" ]; then
        echo "INFO: Cleaning untracked files in $module" >&2
        git -C "$module" clean -fd
    fi

    git -C "$module" fetch --tags --quiet
    latest_tag="$(git -C "$module" tag -l --sort=-version:refname | head -n1)"

    if [ "$latest_tag" = "" ]; then
        echo "ERR: No tags found in $module" >&2
        return 1
    fi

    if git -C "$module" diff --quiet HEAD "$latest_tag"; then
        echo "INFO: $module is already at the latest tag: $latest_tag" >&2
        return 0
    fi

    echo "INFO: Updating $module to the latest tag" >&2
    git -C "$module" reset --hard "$latest_tag"
    git -C "$module" clean -fd

    # Update submodules of this submodule if any
    if [ -f "$module/.gitmodules" ]; then
        echo "INFO: Updating submodules of $module" >&2
        git -C "$module" submodule sync --quiet --recursive # URL Update
        git -C "$module" submodule update --init --recursive
        git -C "$module" submodule foreach --recursive 'git reset --hard && git clean -fd'
    fi
}

update_module_by_default_branch() {
    local module="$1"
    local default_branch
    local current_commit
    local target_commit

    if [ ! -d "$module" ]; then
        echo "INFO: $module not found, initializing submodule" >&2
        git submodule update --init --recursive "$module"
    fi

    if ! git -C "$module" diff --quiet HEAD; then
        echo "INFO: Resetting local changes in $module" >&2
        git -C "$module" reset --hard HEAD
    fi

    if [ "$(git -C "$module" ls-files --others --exclude-standard)" != "" ]; then
        echo "INFO: Cleaning untracked files in $module" >&2
        git -C "$module" clean -fd
    fi

    # TODO: git fetch -v --porcelain 으로 default_branch 명 캡쳐 <2025-08-13>

    git -C "$module" fetch --quiet origin
    default_branch=$(git -C "$module" remote show origin | grep 'HEAD branch' | cut -d' ' -f5)

    if [ "$default_branch" = "" ]; then
        echo "ERR: No default branch found for $module" >&2
        return 1
    fi

    current_commit=$(git -C "$module" rev-parse HEAD)
    target_commit=$(git -C "$module" rev-parse "origin/$default_branch")

    if [ "$current_commit" = "$target_commit" ]; then
        echo "INFO: $module is already at the latest commit origin/$default_branch" >&2
        return 0
    fi

    echo "INFO: Updating $module to origin/$default_branch" >&2
    git -C "$module" reset --hard "origin/$default_branch"
    git -C "$module" clean -fd

    if [ -f "$module/.gitmodules" ]; then
        echo "INFO: Updating submodules of $module" >&2
        git -C "$module" submodule update --init --recursive
    fi
}

main() {
    local modules

    cd "$script_dir" # Make sure pwd is not in submodule
    cd "$(git rev-parse --show-toplevel)"

    # NOTE: expand 안하도록 single quote 사용
    # shellcheck disable=SC2016
    modules="$(git submodule --quiet foreach 'echo $path' 2>/dev/null)"
    while IFS= read -r module; do
        if [[ ${BRANCH_BASED_MODULES[$module]:-} != "" ]]; then
            update_module_by_default_branch "$module"
        else
            update_module_by_tag "$module"
        fi
    done <<<"$modules"
}

main
