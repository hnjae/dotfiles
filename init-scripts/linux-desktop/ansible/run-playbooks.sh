#!/usr/bin/env bash

scriptdir="$(cd -- "$(dirname -- "$0")" && pwd -P)" >/dev/null 2>&1
playbook_dir="$scriptdir/playbooks"

check_cond() {
  if ! command -v ansible >/dev/null 2>&1; then
    echo "Error: ansible is not installed" >&2
    exit 1
  fi
}

main() {
  check_cond

  fd \
    --absolute-path \
    --exact-depth 1 \
    --type f \
    --extension yaml \
    --print0 \
    --search-path \
    "$playbook_dir" |
    sort -z |
    xargs -0 -r ansible-playbook -i inventory.ini --
}

main
