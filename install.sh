#!/bin/sh

set -eu

if [ "$HOME" = "" ]; then
	exit 0
fi

# --- Configuration ---

SOURCE_CONFIG_DIR="_xdg.config-files"
SOURCE_DATA_DIR="_xdg.data-files"
SOURCE_HOME_DIR="_home"

# --- Script Setup ---

script_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

fullSourceConfigDir="${script_dir}/${SOURCE_CONFIG_DIR}"
fullSourceDataDir="${script_dir}/${SOURCE_DATA_DIR}"
fullSourceHomeDir="${script_dir}/${SOURCE_HOME_DIR}"

# --- Colors for better log readability ---
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
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
		scope="${MAGENTA}$2${NC}: "
	else
		scope=""
	fi

	printf "%b%b%s\n" "$severity" "$scope" "$msg"
}

is_internet_connected() {
	if [ "${_INTERNET_CONNECTED_CACHE+x}" != "" ]; then
		return "$_INTERNET_CONNECTED_CACHE"
	fi

	if ping -c 1 1.1.1.1 >/dev/null 2>&1; then
		_INTERNET_CONNECTED_CACHE=0 # connected
	else
		_INTERNET_CONNECTED_CACHE=1
	fi

	return "$_INTERNET_CONNECTED_CACHE"
}

# Arguments:
#   $1: scope
#   $2: Full path to the file/directory
backup_path() {
	scope="$1"
	target_path="$2"

	if [ ! -e "$target_path" ]; then
		return
	fi

	backup_path_="${target_path}.backup.$(date --utc '+%Y%m%dT%H%M%S%Z')"
	log info "$scope" "Existing file/directory found at ${target_path}. Backing up to ${backup_path_}."

	if ! mv -n "$target_path" "$backup_path_"; then
		log error "$scope" "Failed to move existing file/directory to backup location."
		return 1
	fi
}

# Arguments:
#   $1: Full path to the source file/directory
#   $2: Full path to the target link location
link_item() {
	src_path="$1"
	target_path="$2"
	scope=$(basename "$src_path")

	# echo "DEBUG: ${item_name}: Processing" >/dev/stderr

	# -h: True if the file is a symbolic link
	if [ -h "$target_path" ]; then
		current_link_target=$(readlink "$target_path")

		if [ "$current_link_target" = "$src_path" ]; then
			log info "$scope" "Link already exists and points correctly."
			return 0
		else
			if rm "$target_path"; then
				log info "$scope" "Removed existing symlink."
			else
				log error "$scope" "Failed to remove existing symlink: ${target_path}"
				return 1
			fi
		fi
	elif [ -e "$target_path" ]; then
		backup_path "$scope" "$target_path"
	fi

	if ln -v -s "$src_path" "$target_path" >/dev/null 2>&1; then
		log info "$scope" "Created symlink: ${target_path} -> ${src_path}"
	else
		log error "$scope" "Failed to create symlink: ${target_path} -> ${src_path}"
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

	scope=$(basename "$item")
	link_item "$item" "${XDG_CONFIG_HOME}/${scope}"
done

# Loop through hidden files/dirs (e.g., .gitconfig), excluding . and ..
for item in "$fullSourceConfigDir"/.[!.]*; do
	# Check if the glob matched anything and the item actually exists
	[ -e "$item" ] || [ -L "$item" ] || continue
	scope=$(basename "$item")
	link_item "$item" "${XDG_CONFIG_HOME}/${scope}"
done

# Loop through non-hidden files/dirs
for item in "$fullSourceDataDir"/*; do
	# Check if the glob matched anything and the item actually exists
	[ -e "$item" ] || [ -L "$item" ] || continue

	scope=$(basename "$item")
	link_item "$item" "${XDG_DATA_HOME}/${scope}"
done

# Loop through hidden files/dirs (e.g., .local_share_file), excluding . and ..
for item in "$fullSourceDataDir"/.[!.]*; do
	# Check if the glob matched anything and the item actually exists
	[ -e "$item" ] || [ -L "$item" ] || continue

	scope=$(basename "$item")
	link_item "$item" "${XDG_DATA_HOME}/${scope}"
done

# Loop through non-hidden files/dirs
for item in "$fullSourceHomeDir"/*; do
	# Check if the glob matched anything and the item actually exists
	[ -e "$item" ] || [ -L "$item" ] || continue

	scope=$(basename "$item")
	link_item "$item" "${HOME}/${scope}"
done

# Loop through hidden files/dirs (e.g., .local_share_file), excluding . and ..
for item in "$fullSourceHomeDir"/.[!.]*; do
	# Check if the glob matched anything and the item actually exists
	[ -e "$item" ] || [ -L "$item" ] || continue

	scope=$(basename "$item")
	link_item "$item" "${HOME}/${scope}"
done

################################################################################
# Neovim
################################################################################
link_item "$script_dir/nvim" "${XDG_CONFIG_HOME}/nvim"
marker_file="${XDG_STATE_HOME}/nvim/dotfiles-bootstrapped"

if command -v nvim >/dev/null 2>&1 && [ ! -f "$marker_file" ] && is_internet_connected; then
	backup_path nvim "${XDG_STATE_HOME}/nvim"
	backup_path nvim "${XDG_DATA_HOME}/nvim"
	nvim --headless -c "autocmd User VeryLazy ++once Lazy install" -c "qa"
	mkdir -p ~/.local/state/nvim && touch "$marker_file"
fi

################################################################################
# Yazi
################################################################################

# TODO: install plugin <2025-05-28>
link_item "$script_dir/yazi" "${XDG_CONFIG_HOME}/yazi"

if command -v yazi >/dev/null 2>&1; then
	ya pkg install
fi

################################################################################
# zsh
################################################################################

link_item "$script_dir/zsh/.zshenv" "$HOME/.zshenv"
link_item "$script_dir/zsh/xdg.config.home" "$XDG_CONFIG_HOME/zsh"

if hash zsh 2>/dev/null && is_internet_connected; then
	log info "zsh" "initializing zmfw"
	TERM=dumb zsh --interactive -c '
	if ! which zimfw >/dev/null 2>&1; then
		return
	fi

	zimfw init
	'
fi

log info "zsh" "initializing zsh-abbr"
TERM=dumb zsh --interactive -c '
if ! which abbr >/dev/null 2>&1; then
	return
fi

if [[ "$ABBR_USER_ABBREVIATIONS_FILE" != "" && -f "$ABBR_USER_ABBREVIATIONS_FILE" ]]; then
	rm "$ABBR_USER_ABBREVIATIONS_FILE"
fi

abbr import-aliases >/dev/null
'

exit 0
