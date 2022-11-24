#!/usr/bin/env sh

# echo "$#"
[ "$#" -eq 0 ] && exit 0

#-----------------------------
set -e

read_char() {
  stty -icanon -echo
  eval "$1=\$(dd bs=1 count=1 2>/dev/null)"
  stty icanon echo
}

echo "Confirm deleting of: "
for file in "$@"; do
    echo "\t“$file”"
done
echo -n "(y/Any) "

read_char should_run
echo ""
case "$should_run" in
    "y" )
        rm -r -- "$@"
        ;;
    *)
        echo "Not deleting any files."
        ;;
esac

# clear

# echo "Press any keys to close."
# read null
