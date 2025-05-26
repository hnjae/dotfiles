#!/bin/sh

set -eu

# --- Configuration ---

SOURCE_CONFIG_DIR="_xdg.config-files"
SOURCE_DATA_DIR="_xdg.data-files"

# --- Script Setup ---

script_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

fullSourceConfigDir="${script_dir}/${SOURCE_CONFIG_DIR}"
fullSourceDataDir="${script_dir}/${SOURCE_DATA_DIR}"

# --- Colors for better log readability ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Arguments:
#   $1: Severity level
#   $2: scope
#   $3: message
log() {
	msg="$3"

	if [ "$1" = "info" ]; then
		severity="${BLUE}[INFO]${NC} "
	elif [ "$1" = "warning" ]; then
		severity="${YELLOW}[WARNING]${NC} "
	elif [ "$1" = "error" ]; then
		severity="${RED}[ERROR]${NC} "
	else
		severity="[$1] "
	fi

	if [ "$2" != "" ]; then
		scope="${GREEN}[$2]${NC} "
	else
		scope=""
	fi

	printf "%b%b%s\n" "$severity" "$scope" "$msg" >/dev/stderr
}

# Arguments:
#   $1: Full path to the source file/directory
#   $2: Full path to the target link location
link_item() {
	src_path="$1"
	target_path="$2"
	item_name=$(basename "$src_path")

	# echo "DEBUG: ${item_name}: Processing" >/dev/stderr

	if [ -h "$target_path" ]; then
		current_link_target=$(readlink "$target_path")

		if [ "$current_link_target" = "$src_path" ]; then
			log info "$item_name" "Link already exists and points correctly."
			return 0
		else
			if rm "$target_path"; then
				log info "$item_name" "Removed existing symlink."
			else
				log error "$item_name" "Failed to remove existing symlink: ${target_path}"
				return 1
			fi
		fi
	elif [ -e "$target_path" ]; then
		backup_path="${target_path}.backup.$(date --utc '+%Y%m%dT%H%M%S%Z')"

		log info "$item_name" "Existing file/directory found at ${target_path}. Backing up to ${backup_path}."

		if ! mv -n "$target_path" "$backup_path"; then
			log error "$item_name" "Failed to move existing file/directory to backup location."
			return 1
		fi
	fi

	if ln -v -s "$src_path" "$target_path" >/dev/null 2>&1; then
		log info "$item_name" "Created symlink: ${target_path} -> ${src_path}"
	else
		log error "$item_name" "Failed to create symlink: ${target_path} -> ${src_path}"
		return 1
	fi
}

if [ ! -d "$fullSourceConfigDir" ]; then
	log error "" "Source config directory does not exist: ${fullSourceConfigDir}"
	exit 1
fi
if [ ! -d "$fullSourceDataDir" ]; then
	log error "" "Source data directory does not exist: ${fullSourceDataDir}"
	exit 1
fi

if ! mkdir -p "$XDG_CONFIG_HOME"; then
	log error "" "Failed to create target config directory: ${XDG_CONFIG_HOME}"
	exit 1
fi

if ! mkdir -p "$XDG_DATA_HOME"; then
	log error "" "Failed to create target data directory: ${XDG_DATA_HOME}"
	exit 1
fi

################################################################################
# PROCESS FILES AND DIRECTORIES
################################################################################

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

link_item "$script_dir/nvim" "${XDG_CONFIG_HOME}/nvim"
link_item "$script_dir/yazi" "${XDG_CONFIG_HOME}/yazi"

exit 0
