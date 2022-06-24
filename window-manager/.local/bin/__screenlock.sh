#!/usr/bin/env sh

# grim -q 0 -o /tmp/lockscreen.png
# magick /tmp/lockscreen.png -resize 1% /tmp/lockscreen.png

type 1password < /dev/null > /dev/null 2>&1 \
    && 1password --lock > /dev/null 2>&1

if [ "$XDG_SESSION_DESKTOP" = gnome -o "$XDG_SESSION_DESKTOP" = kde ]; then
    # TODO: implement this <2022-04-12, Hyunjae Kim> #
    exit
fi

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    if type magick > /dev/null && type grim > /dev/null; then
        grim -t ppm /tmp/lockscreen.png
        magick /tmp/lockscreen.png -scale "2.5%" /tmp/lockscreen.png
        magick /tmp/lockscreen.png -scale "4000%" /tmp/lockscreen.png
        swaylock -i /tmp/lockscreen.png
    else
        swaylock
    fi
elif [ "$XDG_SESSION_TYPE" = "x11" ]; then
    xsecurelock
fi
