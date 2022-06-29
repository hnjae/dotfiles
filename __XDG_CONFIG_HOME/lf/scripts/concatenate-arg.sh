#!/usr/bin/env sh

exe="$1"
type "$exe" > /dev/null || exit 1

shift
# big_arg="$1"
# shift
big_arg=""
for arg in "$@"; do
    big_arg="${big_arg} ${arg}"
done
big_arg=`echo "$big_arg" | xargs`
"$exe" "$big_arg"
