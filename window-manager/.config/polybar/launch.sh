#!/usr/bin/bash

non96="DP-2.1"
## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

primary_monitor=$(polybar -m | grep "primary" | cut -d":" -f1)
if [ "$primary_monitor" = "eDP-1" -o "$primary_monitor" = "eDP-1-1" ]; then
	nohup polybar laptop_primary < /dev/null > /dev/null 2>&1 &
else
	nohup polybar external_primary < /dev/null > /dev/null 2>&1 &
fi

# for m in $(xrandr --query | grep " primary" | cut -d" " -f1); do
# 가끔 모니터 연결되었는데 primary 가 없는 경우도 있음. 이럴 때는 보조 모니터
# 용 polybar 은 띄우지 말기.
if [ "$primary_monitor" ]; then
	for m in $(polybar -m | sed '/primary/d' | cut -d":" -f1); do
		if [ "$m" = "$non96" ]; then
			MONITOR="$m" nohup polybar nonprimary-96 < /dev/null > /dev/null 2>&1 &
		else
			MONITOR="$m" nohup polybar nonprimary < /dev/null > /dev/null 2>&1 &
		fi
	done
fi
