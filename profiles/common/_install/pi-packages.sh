#!/bin/sh
# Reconcile the pi packages declared in ~/.pi/agent/settings.json.
#
# The declaration is tracked (settings.json); the installation under
# ~/.pi/agent/npm/ is not. `pi update --extensions` installs a declared package
# that is missing and upgrades the rest to the newest version the declaration
# allows. Nothing is pinned, so a run may move a package forward; with nothing
# to do it prints "Packages are already up to date" and writes no file.
#
# Pi also retries this installation on its next start, so this step exists to
# surface the failure during install rather than at first launch, and it never
# fails the dotfiles install itself.

set -eu

if ! command -v pi >/dev/null 2>&1; then
    echo "INFO: pi is not installed; skipping package reconciliation" >&2
    exit 0
fi

if ! output="$(pi update --extensions 2>&1)"; then
    echo "WARNING: reconciling pi packages failed; pi retries at startup" >&2
    printf '%s\n' "$output" >&2
    exit 0
fi

printf '%s\n' "$output" |
    while IFS= read -r line; do
        if [ "$line" != "" ]; then
            printf 'INFO: %s\n' "$line" >&2
        fi
    done
