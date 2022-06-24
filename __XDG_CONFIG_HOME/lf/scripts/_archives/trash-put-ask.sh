#!/usr/bin/env sh

# TODO: <space>로 시작하는 파일 처리가 안됨. <2022-05-31, Hyunjae Kim>

# echo "$#"
[ "$#" -eq 0 ] && exit 0

#-----------------------------
set -e

read_char() {
  stty -icanon -echo
  eval "$1=\$(dd bs=1 count=1 2>/dev/null)"
  stty icanon echo
}

echo "Confirm trashing of: "
for file in "$@"; do
    echo "\t“$file”"
done
echo -n "(y/Any) "

read_char should_run
echo ""
case "$should_run" in
    "y" )
        trash-put -- "$@"
        ;;
    *)
        echo "Not trashing any files."
        ;;
esac

# clear

# echo "Press any keys to close."
# read null
