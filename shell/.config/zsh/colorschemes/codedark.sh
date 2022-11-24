#!/usr/bin/sh
# scheme: "codedark"
# author: "Tomas Iser (https://github.com/tomasiser)"

if [ "$TERM" = "linux" ]; then
  /bin/echo -e "
  \e]P01e1e1e
  \e]P1d16969
  \e]P2608b4e
  \e]P3d7ba7d
  \e]P4569cd6
  \e]P5c586c0
  \e]P69cdcfe
  \e]P7d4d4d4
  \e]P83c3c3c
  \e]P9d16969
  \e]PA608b4e
  \e]PBd7ba7d
  \e]PC569cd6
  \e]PDc586c0
  \e]PE9cdcfe
  \e]PFffffff
  "
  # get rid of artifacts
  clear
fi
