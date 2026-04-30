#!/usr/bin/env bash
# Create Btrfs subvolumes for paths that should stay out of parent snapshots
#
# Nested Btrfs subvolumes are not included in non-recursive snapshots of their
# parent subvolume. This is useful for disposable cache directories and for
# other data that should persist outside the parent's snapshot lifecycle.
#
# Usage:
#   ./scripts/btrfs-snapshot-excluded-subvolumes.sh
#   ./scripts/btrfs-snapshot-excluded-subvolumes.sh [--cow PATH ...] [--nocow PATH ...]
#
# Bare path arguments are treated like --cow.

set -euo pipefail

readonly COW_POLICY_KEEP_COW="keep-cow"
readonly COW_POLICY_NOCOW_ON_NON_RAID="nocow-on-non-raid"

XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

DEFAULT_NOCOW_ON_NON_RAID_DIRS=(
    "${XDG_CACHE_HOME}/nix"
    "${XDG_CACHE_HOME}/thumbnails"
    "${XDG_DATA_HOME}/zoxide"
)
DEFAULT_COW_SNAPSHOT_EXCLUDED_DIRS=(
    "${XDG_CACHE_HOME}/oh-my-posh"
    "${XDG_CACHE_HOME}/pip"
    "${XDG_CACHE_HOME}/prek"

    "${XDG_DATA_HOME}/flatpak"
    "${XDG_DATA_HOME}/direnv"
    "${XDG_DATA_HOME}/devenv"
    "${XDG_DATA_HOME}/containers"
    "${XDG_DATA_HOME}/cargo"

    "${XDG_DATA_HOME}/go"
    "${XDG_CACHE_HOME}/go"
    "${XDG_CACHE_HOME}/go-build"

    "${XDG_CACHE_HOME}/nvim"
    "${XDG_DATA_HOME}/nvim"
    "${XDG_STATE_HOME}/nvim"

    "${XDG_CACHE_HOME}/npm"
    "${XDG_DATA_HOME}/pnpm"
    "${XDG_STATE_HOME}/pnpm"

    "${XDG_CACHE_HOME}/BraveSoftware"
    "${XDG_CONFIG_HOME}/BraveSoftware"
    "${XDG_CONFIG_HOME}/1Password"
)
OPTIONAL_EXISTING_NOCOW_ON_NON_RAID_DIRS=(
    "${XDG_DATA_HOME}/baloo"
    "${XDG_DATA_HOME}/klipper"
    "${XDG_DATA_HOME}/kactivitymanagerd"
)
OPTIONAL_EXISTING_COW_SNAPSHOT_EXCLUDED_DIRS=(
    "${XDG_CACHE_HOME}/fontconfig"
    "${XDG_CACHE_HOME}/mesa_shader_cache"
    "${XDG_CACHE_HOME}/kwin"
    "${XDG_CACHE_HOME}/plasmashell"
    "${XDG_CACHE_HOME}/polkit-kde-authentication-agent-1"
    "${XDG_CACHE_HOME}/ksplash"
    "${XDG_CACHE_HOME}/kscreenlocker_greet"

    "${XDG_DATA_HOME}/libkunitconversion"
    "${XDG_DATA_HOME}/kwalletd"
    "${XDG_STATE_HOME}/yazi"
)

die() {
    printf 'ERR: %s\n' "$1" >&2
    exit 1
}

info() {
    printf 'INFO: %s\n' "$1"
}

usage() {
    printf '%s\n' \
        "Usage:" \
        "  $0" \
        "  $0 [--cow PATH ...] [--nocow PATH ...]" \
        "" \
        "Options:" \
        "  --cow      Create subvolumes without disabling CoW." \
        "  --nocow    Create subvolumes and disable CoW only on non-RAID Btrfs." \
        "" \
        "Bare path arguments are treated like --cow."
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

    rm -rf "$backup_path"
}

recreate_btrfs_subvolume() {
    local path="$1"
    local cow_policy="$2"
    local backup_dir="${path}.bak.$$"

    if [[ -e $path ]]; then
        info "Moving existing $path to $backup_dir"
        mv "$path" "$backup_dir"
    fi

    info "Creating Btrfs subvolume at $path"
    btrfs subvolume create "$path"

    case "$cow_policy" in
    "$COW_POLICY_NOCOW_ON_NON_RAID")
        info "Disabling CoW for $path"
        chattr +C "$path"
        ;;
    "$COW_POLICY_KEEP_COW")
        if has_nocow_attribute "$path"; then
            info "Enabling CoW for $path"
            chattr -C "$path"
        fi
        ;;
    *)
        die "Unknown CoW policy: $cow_policy"
        ;;
    esac

    if [[ -d $backup_dir ]]; then
        info "Restoring contents from $backup_dir to $path"
        rsync --info=progress2 -h -aHAWEs --numeric-ids --no-inc-recursive --delete -- "$backup_dir/" "$path/"
        cleanup_backup "$backup_dir"
        info "Removed backup $backup_dir"
    fi
}

ensure_btrfs_subvolume() {
    local path="$1"
    local cow_policy="$2"
    local parent_dir fs_type effective_cow_policy

    parent_dir="$(dirname "$path")"
    mkdir -p "$parent_dir"

    fs_type="$(stat -f -c '%T' "$parent_dir" 2>/dev/null)" || die "Cannot stat $parent_dir"
    [[ $fs_type == "btrfs" ]] || die "$parent_dir is not on Btrfs (detected: $fs_type)"

    effective_cow_policy="$cow_policy"
    case "$cow_policy" in
    "$COW_POLICY_NOCOW_ON_NON_RAID")
        require_command chattr
        require_command lsattr
        if is_btrfs_raid "$parent_dir"; then
            effective_cow_policy="$COW_POLICY_KEEP_COW"
        fi
        ;;
    "$COW_POLICY_KEEP_COW")
        require_command chattr
        require_command lsattr
        ;;
    *)
        die "Unknown CoW policy: $cow_policy"
        ;;
    esac

    if is_btrfs_subvolume "$path"; then
        if [[ $effective_cow_policy == "$COW_POLICY_NOCOW_ON_NON_RAID" ]] && ! has_nocow_attribute "$path"; then
            info "$path is a Btrfs subvolume without NOCOW. Recreating it."
            recreate_btrfs_subvolume "$path" "$COW_POLICY_NOCOW_ON_NON_RAID"
            info "Done. $path is now a Btrfs subvolume with CoW disabled."
            return 0
        fi

        if [[ $effective_cow_policy == "$COW_POLICY_KEEP_COW" ]] && has_nocow_attribute "$path"; then
            info "$path is a Btrfs subvolume with NOCOW. Recreating it."
            recreate_btrfs_subvolume "$path" "$COW_POLICY_KEEP_COW"
            info "Done. $path is now a Btrfs subvolume without NOCOW."
            return 0
        fi

        if [[ $effective_cow_policy == "$COW_POLICY_NOCOW_ON_NON_RAID" ]]; then
            info "$path is already a Btrfs subvolume with CoW disabled. Nothing to do."
        elif [[ $cow_policy == "$COW_POLICY_NOCOW_ON_NON_RAID" ]]; then
            info "$path is already a Btrfs subvolume on Btrfs RAID. Nothing to do."
        else
            info "$path is already a Btrfs subvolume without NOCOW. Nothing to do."
        fi
        return 0
    fi

    if [[ -e $path && ! -d $path ]]; then
        die "$path exists but is not a directory"
    fi

    recreate_btrfs_subvolume "$path" "$effective_cow_policy"

    if [[ $effective_cow_policy == "$COW_POLICY_NOCOW_ON_NON_RAID" ]]; then
        info "Done. $path is now a Btrfs subvolume with CoW disabled."
    elif [[ $cow_policy == "$COW_POLICY_NOCOW_ON_NON_RAID" ]]; then
        info "Done. $path is now a Btrfs subvolume on Btrfs RAID."
    else
        info "Done. $path is now a Btrfs subvolume without NOCOW."
    fi
}

ensure_btrfs_subvolume_if_exists() {
    local path="$1"
    local cow_policy="$2"

    if [[ ! -e $path ]]; then
        info "$path does not exist. Skipping optional path."
        return 0
    fi

    ensure_btrfs_subvolume "$path" "$cow_policy"
}

ensure_btrfs_subvolumes() {
    local cow_policy="$1"
    shift

    local path
    for path in "$@"; do
        ensure_btrfs_subvolume "$path" "$cow_policy"
    done
}

ensure_btrfs_subvolumes_if_exist() {
    local cow_policy="$1"
    shift

    local path
    for path in "$@"; do
        ensure_btrfs_subvolume_if_exists "$path" "$cow_policy"
    done
}

parse_args() {
    local mode="$COW_POLICY_KEEP_COW"

    REQUESTED_COW_DIRS=()
    REQUESTED_NOCOW_ON_NON_RAID_DIRS=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
        --cow)
            mode="$COW_POLICY_KEEP_COW"
            ;;
        --nocow)
            mode="$COW_POLICY_NOCOW_ON_NON_RAID"
            ;;
        -h | --help)
            usage
            exit 0
            ;;
        --)
            shift
            while [[ $# -gt 0 ]]; do
                REQUESTED_COW_DIRS+=("$1")
                shift
            done
            return 0
            ;;
        -*)
            die "Unknown option: $1"
            ;;
        *)
            case "$mode" in
            "$COW_POLICY_KEEP_COW")
                REQUESTED_COW_DIRS+=("$1")
                ;;
            "$COW_POLICY_NOCOW_ON_NON_RAID")
                REQUESTED_NOCOW_ON_NON_RAID_DIRS+=("$1")
                ;;
            *)
                die "Unknown CoW policy: $mode"
                ;;
            esac
            ;;
        esac

        shift
    done
}

if [[ $# -gt 0 ]]; then
    parse_args "$@"
fi

# Check that btrfs tools are available
require_command btrfs

if [[ $# -gt 0 ]]; then
    ensure_btrfs_subvolumes "$COW_POLICY_NOCOW_ON_NON_RAID" "${REQUESTED_NOCOW_ON_NON_RAID_DIRS[@]}"
    ensure_btrfs_subvolumes "$COW_POLICY_KEEP_COW" "${REQUESTED_COW_DIRS[@]}"
else
    ensure_btrfs_subvolumes "$COW_POLICY_NOCOW_ON_NON_RAID" "${DEFAULT_NOCOW_ON_NON_RAID_DIRS[@]}"
    ensure_btrfs_subvolumes "$COW_POLICY_KEEP_COW" "${DEFAULT_COW_SNAPSHOT_EXCLUDED_DIRS[@]}"
    ensure_btrfs_subvolumes_if_exist "$COW_POLICY_NOCOW_ON_NON_RAID" "${OPTIONAL_EXISTING_NOCOW_ON_NON_RAID_DIRS[@]}"
    ensure_btrfs_subvolumes_if_exist "$COW_POLICY_KEEP_COW" "${OPTIONAL_EXISTING_COW_SNAPSHOT_EXCLUDED_DIRS[@]}"
fi
