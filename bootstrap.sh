#!/bin/sh

set -eu

# script_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

# --- Colors for better log readability ---
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

hostname_="$(hostname)"

# Arguments:
#   $1: Severity level
#   $2: scope
#   $3: message
log() {
  msg="$3"

  if [ "$1" = "info" ]; then
    severity="${BLUE}[INFO]${NC} "
  elif [ "$1" = "warn" ]; then
    severity="${YELLOW}[WARN]${NC} "
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
  if [ "${_internet_connected_cache+x}" != "" ]; then
    return "$_internet_connected_cache"
  fi

  if ping -c 1 1.1.1.1 >/dev/null 2>&1; then
    _internet_connected_cache=0 # connected
  else
    _internet_connected_cache=1
  fi

  return "$_internet_connected_cache"
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

write_secrets() {
  op_list="$(op account list)"

  if [ "$op_list" = "" ]; then
    log warn "op" "No 1Password account found. Please log in to your account first."
    return 1
  fi

  log info "op" "Writing secrets: age"

  mkdir -p "$XDG_CONFIG_HOME/sops/age"

  chmod 700 "$XDG_CONFIG_HOME/sops"
  chmod 700 "$XDG_CONFIG_HOME/sops/age"
  age_key_path="$XDG_CONFIG_HOME/sops/age/keys.txt"
  op read 'op://Secrets/ssh-home/age/private key' >"$age_key_path"
  chmod 600 "$age_key_path"

  # log info "op" "Writing SSH Key"
  # TODO: gnupg 키 <2025-08-11>
  # TODO: ssh 키 <2025-08-11>

  return 0
}

configure_default_app() {
  log info "xdg" "Configuring default applications"

  xdg-settings set default-web-browser brave-desktop.desktop

  return 0
}

main() {
  marker_file="${XDG_STATE_HOME}/dotfiles-bootstrapped"
  is_bootstrapped=1

  neovim_marker_file="${XDG_STATE_HOME}/nvim/lazyvim-initialized"
  if [ ! -f "$neovim_marker_file" ] && command -v nvim >/dev/null 2>&1; then
    if is_internet_connected; then
      log info "nvim" "Initializing LazyVim"

      backup_path nvim "${XDG_STATE_HOME}/nvim"
      backup_path nvim "${XDG_DATA_HOME}/nvim"
      nvim --headless -c "autocmd User VeryLazy ++once Lazy install" -c "qa"
      mkdir -p "${XDG_STATE_HOME}/nvim" && touch "$neovim_marker_file"

      # TODO: install mason headlessly <2025-08-11>
    else
      is_bootstrapped=0
    fi
  fi

  if command -v zsh >/dev/null 2>&1 && is_internet_connected; then
    log info "zsh" "Initializing zimfw"

    TERM=dumb zsh --interactive -c '
      if ! command -v zimfw >/dev/null 2>&1; then
        return
      fi

      zimfw init
    '
  else
    is_bootstrapped=0
  fi

  if [ "$hostname_" = "osiris" ] || [ "$hostname_" = "isis" ]; then
    if ! configure_default_app; then
      is_bootstrapped=0
    fi

    if ! write_secrets; then
      is_bootstrapped=0
    fi
  fi

  if [ "$is_bootstrapped" -eq 1 ]; then
    echo ""
    echo "Bootstrapping completed successfully." >/dev/stderr
    mkdir -p "$XDG_STATE_HOME" && touch "$marker_file"
  else
    echo ""
    echo "THERE WAS ERROR WHILE BOOTSTRAPPING" >/dev/stderr
    echo "Please check the logs above for more details." >/dev/stderr
    echo "You can try running this script again after fixing the issues." >/dev/stderr
  fi
}

main
