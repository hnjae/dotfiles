#!/bin/sh

# SPDX-License-Identifier: AGPL-3.0-or-later
# SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

main() {
    # Remove non-exists path
    zoxide query --list --all | while read -r path; do
        if [ ! -d "$path" ]; then
            echo "INFO: Removing: $path"
            zoxide remove "$path"
        fi
    done

    zoxide query --list --all | grep -E '(^|/)foo($|/|_|-)' | while read -r path; do
        echo "INFO: Removing: $path"
        zoxide remove "$path"
    done

    zoxide query -l | grep -E '(^|/)_' | while read -r path; do
        echo "INFO: Removing: $path"
        zoxide remove "$path"
    done
}

main
