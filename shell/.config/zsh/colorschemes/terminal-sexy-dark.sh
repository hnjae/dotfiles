#!/bin/sh
if [ "$TERM" = "linux" ]; then
  /bin/echo -e "
  \e]P0151515
  \e]P1ac4142
  \e]P290a959
  \e]P3f4bf75
  \e]P46a9fb5
  \e]P5aa759f
  \e]P675b5aa
  \e]P7d0d0d0
  \e]P8505050
  \e]P9ac4142
  \e]PA90a959
  \e]PBf4bf75
  \e]PC6a9fb5
  \e]PDaa759f
  \e]PE75b5aa
  \e]PFf5f5f5
  "
  # get rid of artifacts
  clear
fi
