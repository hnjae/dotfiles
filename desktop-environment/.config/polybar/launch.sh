#!/usr/bin/env sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Wait until xrandr fin
sleep 4

# primary_monitor=$(polybar -m | grep "primary" | cut -d":" -f1)
primary_monitor=$(xrandr | grep "primary" | awk '{print $1}' | head -n1)

MONITOR="$primary_monitor" exec polybar primary < /dev/null > /dev/null 2>&1 &

# NOTE: Bashism-code
# if [ "${primary_monitor:0:3}" = "eDP"  ]; then
#     exec polybar laptop_primary < /dev/null > /dev/null 2>&1 &
# else
#     exec polybar external_primary < /dev/null > /dev/null 2>&1 &
# fi

# for m in $(xrandr --query | grep " primary" | cut -d" " -f1); do
# 가끔 모니터 연결되었는데 primary 가 없는 경우도 있음. 이럴 때는 보조 모니터
# 용 polybar 은 띄우지 말기.
for m in $(xrandr | sed '/primary/d' | grep " connected" | awk '{print $1}'); do
    MONITOR="$m" exec polybar nonprimary < /dev/null > /dev/null 2>&1 &
done
