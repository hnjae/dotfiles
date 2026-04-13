#!/usr/bin/env bash
# Create disposable Btrfs subvolumes for selected paths
#
# Regenerable or disposable directories can live in dedicated subvolumes
# so they stay out of snapshots and remain easy to clean up.
#
# Usage: ./scripts/btrfs-disposable-subvolumes.sh [/path/to/dir ...]

set -euo pipefail

XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
DEFAULT_DISPOSABLE_DIRS=(
    "${XDG_CACHE_HOME}/thumbnails"
    "${XDG_CACHE_HOME}/nix"
)
OPTIONAL_EXISTING_DISPOSABLE_DIRS=(
    "${XDG_DATA_HOME}/baloo"
    "${XDG_DATA_HOME}/klipper"
)

die() {
    printf 'ERR: %s\n' "$1" >&2
    exit 1
}

info() {
    printf 'INFO: %s\n' "$1"
}

require_command() {
    local command_name="$1"

    command -v "$command_name" >/dev/null 2>&1 || die "$command_name is not installed"
}

is_btrfs_subvolume() {
    local path="$1"
    local inode

    [[ -d $path ]] || return 1

    inode="$(stat -c '%i' "$path" 2>/dev/null)" || return 1
    [[ $inode == 256 ]]
}

is_btrfs_raid() {
    local path="$1"
    local line

    while IFS= read -r line; do
        if [[ $line =~ ^(Data|Metadata|System),[[:space:]]*RAID[[:alnum:]]*: ]]; then
            return 0
        fi
    done < <(btrfs filesystem df "$path")

    return 1
}

has_nocow_attribute() {
    local path="$1"
    local attrs

    [[ -e $path ]] || return 1

    attrs="$(lsattr -d "$path" 2>/dev/null)" || return 1
    [[ ${attrs%% *} == *C* ]]
}

cleanup_backup() {
    local backup_path="$1"

    [[ -e $backup_path ]] || return 0

    if is_btrfs_subvolume "$backup_path"; then
        btrfs subvolume delete "$backup_path"
    else
        rm -rf "$backup_path"
    fi
}

recreate_btrfs_subvolume() {
    local path="$1"
    local set_nocow="$2"
    local backup_dir="${path}.bak.$$"

    if [[ -e $path ]]; then
        info "Moving existing $path to $backup_dir"
        mv "$path" "$backup_dir"
    fi

    info "Creating Btrfs subvolume at $path"
    btrfs subvolume create "$path"

    if [[ $set_nocow == true ]]; then
        info "Disabling CoW for $path"
        chattr +C "$path"
    fi

    if [[ -d $backup_dir ]]; then
        info "Restoring contents from $backup_dir to $path"
        rsync --info=progress2 -h -aHAWEs --numeric-ids --no-inc-recursive --delete -- "$backup_dir/" "$path/"
        cleanup_backup "$backup_dir"
        info "Removed backup $backup_dir"
    fi
}

ensure_btrfs_subvolume() {
    local path="$1"
    local parent_dir fs_type should_disable_cow

    parent_dir="$(dirname "$path")"
    mkdir -p "$parent_dir"

    fs_type="$(stat -f -c '%T' "$parent_dir" 2>/dev/null)" || die "Cannot stat $parent_dir"
    [[ $fs_type == "btrfs" ]] || die "$parent_dir is not on Btrfs (detected: $fs_type)"

    should_disable_cow=false
    if ! is_btrfs_raid "$parent_dir"; then
        should_disable_cow=true
        require_command chattr
        require_command lsattr
    fi

    if is_btrfs_subvolume "$path"; then
        if [[ $should_disable_cow == true ]] && ! has_nocow_attribute "$path"; then
            info "$path is a Btrfs subvolume without NOCOW. Recreating it."
            recreate_btrfs_subvolume "$path" true
            info "Done. $path is now a Btrfs subvolume with CoW disabled."
            return 0
        fi

        if [[ $should_disable_cow == true ]]; then
            info "$path is already a Btrfs subvolume with CoW disabled. Nothing to do."
        else
            info "$path is already a Btrfs subvolume on Btrfs RAID. Nothing to do."
        fi
        return 0
    fi

    if [[ -e $path && ! -d $path ]]; then
        die "$path exists but is not a directory"
    fi

    recreate_btrfs_subvolume "$path" "$should_disable_cow"

    if [[ $should_disable_cow == true ]]; then
        info "Done. $path is now a Btrfs subvolume with CoW disabled."
    else
        info "Done. $path is now a Btrfs subvolume."
    fi
}

ensure_btrfs_subvolume_if_exists() {
    local path="$1"

    if [[ ! -e $path ]]; then
        info "$path does not exist. Skipping optional path."
        return 0
    fi

    ensure_btrfs_subvolume "$path"
}

# Check that btrfs tools are available
require_command btrfs

if [[ $# -gt 0 ]]; then
    DISPOSABLE_DIRS=("$@")
else
    DISPOSABLE_DIRS=("${DEFAULT_DISPOSABLE_DIRS[@]}")
fi

for path in "${DISPOSABLE_DIRS[@]}"; do
    ensure_btrfs_subvolume "$path"
done

if [[ $# -eq 0 ]]; then
    for path in "${OPTIONAL_EXISTING_DISPOSABLE_DIRS[@]}"; do
        ensure_btrfs_subvolume_if_exists "$path"
    done
fi
