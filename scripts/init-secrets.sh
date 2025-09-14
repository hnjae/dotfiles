#!/bin/sh

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"

check_cond() {
  if ! command -v op >/dev/null 2>&1; then
    echo "Error: op is not installed" >&2
    exit 1
  fi

  op_list="$(op account list)"
  if [ "$op_list" = "" ]; then
    echo "Error: No 1Password account found .Please log in to your account first" >&2
    exit 1
  fi
}

main() {
  check_cond

  age_key_path="$XDG_CONFIG_HOME/sops/age/keys.txt"

  if [ ! -r "$age_key_path" ]; then
    echo "Writing secrets: ${age_key_path}" >&2

    mkdir -p "$XDG_CONFIG_HOME/sops/age"
    chmod 700 "$XDG_CONFIG_HOME/sops"
    chmod 700 "$XDG_CONFIG_HOME/sops/age"
    op read 'op://Personal/ssh-home/age/private-key' >"$age_key_path"
    chmod 600 "$age_key_path"
  fi

  echo "Writing secrets: openrouter api-key" >&2
  op read "op://Personal/openrouter-local/credential" | secret-tool store --label=openrouter-local api openrouter

  # TODO: gnupg 키 <2025-08-11>
  # TODO: ssh 키 <2025-08-11>

  return 0
}

main
