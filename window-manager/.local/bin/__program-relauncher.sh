#!/usr/bin/env bash

type "$1" > /dev/null || exit 1

# bash는 UID 지정이 가능하나 dash 는 불가능
# UID=1000

killall -q "$1"

# Wait until the processes have been shut down
while pgrep --uid "$UID" -x "$1" > /dev/null; do sleep 0.4; done

sleep 1

nohup "$@" < /dev/null > /dev/null 2>&1 &
