#!/usr/bin/sh

# run all system xinitrc shell scripts.
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for i in /etc/X11/xinit/xinitrc.d/* ; do
  if [ -x "$i" ]; then
    . "$i"
  fi
  done
fi

# Xresources
if [ -d /etc/X11/Xresources ]; then
  for i in /etc/X11/Xresources/*; do
    [ -f $i ] && xrdb -merge $i
  done
elif [ -f /etc/X11/Xresources ]; then
  xrdb -merge /etc/X11/Xresources
fi
[ -f $HOME/.Xresources ] && xrdb -merge $HOME/.Xresources
# [ -f "$HOME/.xprofile" ] && . "$HOME/.xprofile"

# DESKTOP_SESSION="${DESKTOP_SESSION:cinnamon-session}"
# DESKTOP_SESSION="${DESKTOP_SESSION:mate-session}"
# exec "mate-session"
exec "cinnamon-session"
