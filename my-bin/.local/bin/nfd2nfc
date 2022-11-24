#!/usr/bin/env sh

# -z: true if string length is zero
[ -z "$1" ] && arg="." || arg="$1"

convmv -r -f utf-8 -t utf-8 --nfc "$arg"

echo "\n--------------"
read -p "Continue? (y/Any)" should_run
[ "$should_run" != "y" ] && echo "O.K. No" && exit 1

convmv -r -f utf-8 -t utf-8 --nfc "$arg" --notest
