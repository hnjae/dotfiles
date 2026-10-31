#!/bin/sh
# Hold a systemd sleep inhibitor while Claude Code works on a prompt.
# Usage: sleep-inhibit.sh start|stop   (hook JSON on stdin)
# One inhibitor per session; its process group id is kept in $XDG_RUNTIME_DIR.

set -eu

action="${1:-}"
session_id="$(jq -r '.session_id // empty')"
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
        --why="Claude Code is working" --mode=block sleep infinity
    ' sh "$pid_file" >/dev/null 2>&1 </dev/null
    ;;
stop)
    if holder_alive; then
        kill -- "-$(cat "$pid_file")" 2>/dev/null || true
    fi
    rm -f "$pid_file"
    ;;
esac
