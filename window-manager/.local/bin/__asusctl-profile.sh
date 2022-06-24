#!/usr/bin/env sh

asusctl profile --next
cur_mode=`asusctl profile --profile-get | sed 's/.* //'`

case "$cur_mode" in
    "Balanced")
        icons="preferences-system-power-management"
        # icons="preferences-system-power-management,preferences-system-power,power-profile-balanced-symbolic,power-profile-balanced,preferences-system-performance"
    ;;
    "Performance")
        icons="preferences-system-power-management"
        # icons="preferences-system-power-management,preferences-system-power,power-profile-performance-symbolic,power-profile-performance,preferences-system-performance"
    ;;
    "Quiet")
        # icons="preferences-system-power-management,preferences-system-power,power-profile-power-saver-symbolic,power-profile-power-saver,preferences-system-performance"
        icons="preferences-system-power-management"
esac

notify-send "Power Profile" "$cur_mode" "--urgency=normal" "--icon=$icons"
# "--category=device"
