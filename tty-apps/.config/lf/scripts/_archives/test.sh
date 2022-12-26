#!/usr/bin/dash

# https://stackoverflow.com/questions/8725925/how-to-read-just-a-single-character-in-shell-script
read_char() {
  stty -icanon -echo
  eval "$1=\$(dd bs=1 count=1 2>/dev/null)"
  stty icanon echo
}
read_char char
echo "got $char"
