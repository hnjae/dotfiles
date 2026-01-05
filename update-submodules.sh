#!/usr/bin/env bash

# git submodule foreach git fetch

set -euf

update_module_by_tag() {
    local module="$1"
    if [ ! -d "$module" ]; then
        echo "[INFO] $module not found, initializing submodule" >&2
        git submodule update --init --recursive "$module"
        # This will fetch main/master branch
    fi

    if ! git -C "$module" diff --quiet HEAD; then
        echo "[INFO] Resetting local changes in $module" >&2
        git -C "$module" reset --hard HEAD
    fi

    if [ "$(git -C "$module" ls-files --others --exclude-standard)" != "" ]; then
        echo "[INFO] Cleaning untracked files in $module" >&2
        git -C "$module" clean -fd
    fi

    local latest_tag

    git -C "$module" fetch --tags --quiet
    latest_tag="$(git -C "$module" describe --tags --abbrev=0)"

    if [ "$latest_tag" = "" ]; then
        echo "[ERROR] No tags found in $module" >&2
        return 1
    fi

    if git -C "$module" diff --quiet HEAD "$latest_tag"; then
        echo "[INFO] $module is already at the latest tag: $latest_tag" >&2
        return 0
    fi

    echo "[INFO] Updating $module to the latest tag" >&2
    git -C "$module" reset --hard "$latest_tag"
    git -C "$module" clean -fd

    # Update submodules of this submodule if any
    if [ -f "$module/.gitmodules" ]; then
        echo "[INFO] Updating submodules of $module" >&2
        git -C "$module" submodule update --init --recursive
    fi
}

#!!!!!!!!!!!!!!!!!!!!!!!
# HAVE NOT TESTED THIS
#!!!!!!!!!!!!!!!!!!!!!!!
update_module_by_default_branch() {
    local module="$1"
    if [ ! -d "$module" ]; then
        echo "[INFO] $module not found, initializing submodule" >&2
        git submodule update --init --recursive "$module"
        # This will fetch main/master branch
        return 0
    fi

    if ! git -C "$module" diff --quiet HEAD; then
        echo "[INFO] Resetting local changes in $module" >&2
        git -C "$module" reset --hard HEAD
    fi

    if [ "$(git -C "$module" ls-files --others --exclude-standard)" != "" ]; then
        echo "[INFO] Cleaning untracked files in $module" >&2
        git -C "$module" clean -fd
    fi

    # TODO: git fetch -v --porcelain 으로 default_branch 명 캡쳐 <2025-08-13>

    git -C "$module" fetch --quiet origin
    local default_branch
    default_branch=$(git -C "$module" remote show origin | grep 'HEAD branch' | cut -d' ' -f5)

    if [ "$default_branch" = "" ]; then
        echo "[ERROR] No default branch found for $module" >&2
        return 1
    fi

    if git -C "$module" diff --quiet HEAD "$latest_tag"; then
        echo "[INFO] $module is already at the latest commit origin/$default_branch" >&2
        return 0
    fi

    echo "[INFO] Updating $module to origin/$default_branch" >&2
    git -C "$module" reset --hard "origin/$default_branch"
    git -C "$module" clean -fd

    if [ -f "$module/.gitmodules" ]; then
        echo "[INFO] Updating submodules of $module" >&2
        git -C "$module" submodule update --init --recursive
    fi
}

main() {
    declare -A branch_based_modules
    # branch_based_modules['@xdg-data-home/another-module']=1

    local modules

    # NOTE: expand 안하도록 single quote 사용
    # shellcheck disable=SC2016
    modules="$(git submodule --quiet foreach 'echo $path' 2>/dev/null)"
    while IFS= read -r module; do
        if [[ ${branch_based_modules[$module]:-} != "" ]]; then
            echo "WIP: Implement this"
        else
            update_module_by_tag "$module"
        fi
    done <<<"$modules"
}

main
