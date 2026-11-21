#!/bin/sh

# SPDX-License-Identifier: AGPL-3.0-or-later
# SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

# Hold a systemd sleep inhibitor while Claude Code works on a prompt.
# Usage: sleep-inhibit.sh start|stop   (hook JSON on stdin)
# One inhibitor per session; its process group id is kept in $XDG_RUNTIME_DIR.

set -eu

action="${1:-}"
input="$(cat)"
session_id="$(printf '%s' "$input" | jq -r '.session_id // empty')"
[ "$session_id" != "" ] || exit 0

pid_file="${XDG_RUNTIME_DIR:-/tmp}/claude-sleep-inhibit.$session_id"

holder_alive() {
    [ -f "$pid_file" ] && kill -0 "$(cat "$pid_file")" 2>/dev/null
}

case "$action" in
start)
    holder_alive && exit 0
    # setsid makes the shell a group leader, so `stop` can kill the inhibitor
    # and its `sleep` child together (systemd-inhibit forks instead of exec).
    # shellcheck disable=SC2016  # $$ and $1 must expand in the inner shell
    setsid -f sh -c '
      echo $$ >"$1"
      exec systemd-inhibit --what=sleep --who="Claude Code" \
        --why="Claude Code is working" --mode=block-weak sleep infinity
    ' sh "$pid_file" >/dev/null 2>&1 </dev/null
    ;;
stop)
    # A turn can end while background tasks still run; their completion wakes
    # the session later, so keep the inhibitor until none are in flight.
    if printf '%s' "$input" |
        jq -e '(.background_tasks // []) | length > 0' >/dev/null 2>&1; then
        exit 0
    fi
    if holder_alive; then
        kill -- "-$(cat "$pid_file")" 2>/dev/null || true
    fi
    rm -f "$pid_file"
    ;;
esac
