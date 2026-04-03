#!/bin/sh

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
