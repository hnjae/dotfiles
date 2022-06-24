#!/usr/bin/env sh

[ -f "/sys/class/power_supply/AC0/online" -a `cat "/sys/class/power_supply/AC0/online"` = 1  ] &&  \
    echo "AC Online" || systemctl suspend
