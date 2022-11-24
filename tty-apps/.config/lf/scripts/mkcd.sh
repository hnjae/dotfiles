#!/usr/bin/env sh

# mkcd.sh <id> <args>

id="$1"
shift

big_arg=""
for arg in "$@"; do
    big_arg="${big_arg} ${arg}"
done
big_arg=`echo "$big_arg" | xargs`
mkdir "$big_arg"
lf -remote "send $id load"
lf -remote "send $id cd \"$big_arg\""
