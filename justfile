#!/usr/bin/env -S just --justfile

hostname := `hostname`

_:
    @just --list

stow:
    #!/usr/bin/env bash

    # Based on LLM generated code

    set -eu

    # --- Configuration ---

    SOURCE_CONFIG_DIR="_xdg.config-files"
    SOURCE_DATA_DIR="_xdg.data-files"

    # --- Script Setup ---

    script_dir="$(cd -- "$(dirname -- "")" && pwd -P)" >/dev/null 2>&1

    XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
    XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

    fullSourceConfigDir="${script_dir}/${SOURCE_CONFIG_DIR}"
    fullSourceDataDir="${script_dir}/${SOURCE_DATA_DIR}"

    # Arguments:
    #   $1: Full path to the source file/directory
    #   $2: Full path to the target link location
    link_item() {
        local src_path="$1"
        local target_path="$2"
        local item_name

        item_name=$(basename "$src_path")

        # echo "DEBUG: ${item_name}: Processing" >/dev/stderr

        if [ -h "$target_path" ]; then
            local current_link_target
            current_link_target=$(readlink "$target_path")

            if [ "$current_link_target" = "$src_path" ]; then
                echo "INFO: ${item_name}: Skipping: Link already exists and points correctly." >/dev/stderr
                return 0
            else
                if rm "$target_path"; then
                    echo "INFO: ${item_name}: Removed existing symlink." >/dev/stderr
                else
                    echo "ERROR: ${item_name}: Failed to remove existing symlink: ${target_path}" >/dev/stderr
                    return 1
                fi
            fi
        elif [ -e "$target_path" ]; then
            local backup_path
            backup_path="${target_path}.backup.$(date --utc '+%Y%m%dT%H%M%S%Z')"

            echo "INFO: ${item_name}: Existing file/directory found at ${target_path}. Backing up." >/dev/stderr

            if ! mv -n "$target_path" "$backup_path"; then
                echo "ERROR: ${item_name}: Failed to move ${target_path} to ${backup_path}. Please check permissions or if the backup already exists." >/dev/stderr
                return 1
            fi
        fi

        echo "INFO: ${item_name}: Creating symlink: ${target_path} -> ${src_path}" >/dev/stderr

        if ! ln -v -s "$src_path" "$target_path"; then
            echo "ERROR: ${item_name}: Failed to create link for ${item_name}." >/dev/stderr
            return 1
        fi
    }

    if [ ! -d "$fullSourceConfigDir" ]; then
        echo "ERROR: Source config directory does not exist: ${fullSourceConfigDir}" >/dev/stderr
        exit 1
    fi
    if [ ! -d "$fullSourceDataDir" ]; then
        echo "ERROR: Source data directory does not exist: ${fullSourceDataDir}" >/dev/stderr
        exit 1
    fi

    if ! mkdir -p "$XDG_CONFIG_HOME"; then
        echo "ERROR: Failed to create target config directory: ${XDG_CONFIG_HOME}" >/dev/stderr
        exit 1
    fi

    if ! mkdir -p "$XDG_DATA_HOME"; then
        echo "ERROR: Failed to create target data directory: ${XDG_DATA_HOME}" >/dev/stderr
        exit 1
    fi

    echo ""

    for item in "$fullSourceConfigDir"/*; do
        # Check if the glob matched anything and the item actually exists
        [ -e "$item" ] || [ -L "$item" ] || continue

        item_name=$(basename "$item")
        link_item "$item" "${XDG_CONFIG_HOME}/${item_name}"
    done

    # Loop through hidden files/dirs (e.g., .gitconfig), excluding . and ..
    for item in "$fullSourceConfigDir"/.[!.]*; do
        # Check if the glob matched anything and the item actually exists
        [ -e "$item" ] || [ -L "$item" ] || continue
        item_name=$(basename "$item")
        link_item "$item" "${XDG_CONFIG_HOME}/${item_name}"
    done

    # 4. Process items in the data directory

    # Loop through non-hidden files/dirs
    for item in "$fullSourceDataDir"/*; do
        # Check if the glob matched anything and the item actually exists
        [ -e "$item" ] || [ -L "$item" ] || continue

        item_name=$(basename "$item")
        link_item "$item" "${XDG_DATA_HOME}/${item_name}"
    done

    # Loop through hidden files/dirs (e.g., .local_share_file), excluding . and ..
    for item in "$fullSourceDataDir"/.[!.]*; do
        # Check if the glob matched anything and the item actually exists
        [ -e "$item" ] || [ -L "$item" ] || continue

        item_name=$(basename "$item")
        link_item "$item" "${XDG_DATA_HOME}/${item_name}"
    done

    exit 0

stow-nvim:
    #!/bin/sh

    set -eu

    CONFIG_NAME="nvim"
    script_dir="$(cd -- "$(dirname -- "")" && pwd -P)" >/dev/null 2>&1
    XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

    [ ! -d "${script_dir}/${CONFIG_NAME}" ] && echo "${script_dir}/${CONFIG_NAME} does not exists." && exit 1
    [ ! -d "$XDG_CONFIG_HOME" ] && mkdir -p "$XDG_CONFIG_HOME"

    target="${XDG_CONFIG_HOME}/${CONFIG_NAME}"

    if [ -h "$target" ]; then
        rm "$target" && echo "rm previous symlinks" >/dev/stderr
    elif [ -e "$target" ]; then \
        echo "${target} exists, moving." >/dev/stderr
        backup_path="${target}.backup.$(date --utc '+%Y%m%dT%H%M%S%Z')"
        mv -n "${target}" "${backup_path}" && echo "mv ${target} to ${backup_path}"; \
    fi

    ln -v -s "${script_dir}/${CONFIG_NAME}" "${target}"

stow-yazi:
    #!/bin/sh

    set -eu

    CONFIG_NAME="yazi"
    script_dir="$(cd -- "$(dirname -- "")" && pwd -P)" >/dev/null 2>&1
    XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

    [ ! -d "${script_dir}/${CONFIG_NAME}" ] && echo "${script_dir}/${CONFIG_NAME} does not exists." && exit 1
    [ ! -d "$XDG_CONFIG_HOME" ] && mkdir -p "$XDG_CONFIG_HOME"

    target="${XDG_CONFIG_HOME}/${CONFIG_NAME}"

    if [ -h "$target" ]; then
        rm "$target" && echo "rm previous symlinks" >/dev/stderr
    elif [ -e "$target" ]; then \
        echo "${target} exists, moving." >/dev/stderr
        backup_path="${target}.backup.$(date --utc '+%Y%m%dT%H%M%S%Z')"
        mv -n "${target}" "${backup_path}" && echo "mv ${target} to ${backup_path}"; \
    fi

    ln -v -s "${script_dir}/${CONFIG_NAME}" "${target}"

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
