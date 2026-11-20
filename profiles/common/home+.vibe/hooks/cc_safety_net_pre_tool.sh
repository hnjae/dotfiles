# Vibe pre_tool adapter for cc-safety-net.
#
# Port of ~/.config/maki/lua/cc_safety_net.lua to Vibe's hook protocol.
# cc-safety-net owns the shell parser, the destructive-command rules, and
# the user's rulebooks in ~/.cc-safety-net; this script only translates
# between Vibe's pre_tool JSON wire format and the check.mjs wrapper that
# calls cc-safety-net's public API (checkCommand).
#
# Protocol (see ~/.vibe/hooks.toml):
#   stdin:  Vibe pre_tool payload {tool_name, tool_input, cwd, ...}
#   stdout: {"decision":"deny","reason":"..."} to deny; empty to allow.
# Failure mode: fail open (exit non-zero -> Vibe warns and lets the call
# proceed), matching FAIL_CLOSED = false in the maki original.

# cc-safety-net is installed globally with bun:
#   bun install -g --trust cc-safety-net@latest
# BUN_INSTALL wins; otherwise bun follows XDG_DATA_HOME, then ~/.bun.
bun_install="${BUN_INSTALL:-}"
xdg_data="${XDG_DATA_HOME:-$HOME/.local/share}"
API_CANDIDATES="
${bun_install:-$xdg_data/bun}/install/global/node_modules/cc-safety-net/dist/api.js
$HOME/.bun/install/global/node_modules/cc-safety-net/dist/api.js
"

# Same wrapper logic as the maki integration (checkCommand per command,
# first deny wins); kept as a local copy so Vibe does not depend on the
# maki config directory.
CHECK_MJS="$HOME/.vibe/hooks/cc_safety_net_check.mjs"

# Fields that hold a shell command line, matching cc_safety_net.lua.
# Nested tool inputs are covered by jq's recursive `..` descent.
fail() {
    # Fail-open warning path: non-zero exit makes Vibe warn and pass through.
    echo "cc_safety_net: $1" >&2
    exit 3
}

node_bin=$(command -v node) || fail "node is missing; command guard disabled"

api=""
for candidate in "${API_CANDIDATES[@]}"; do
    if [ -f "$candidate" ]; then
        api="$candidate"
        break
    fi
done
[ "$api" != "" ] || fail "cc-safety-net api.js is missing; command guard disabled"
[ -f "$CHECK_MJS" ] || fail "check wrapper is missing; command guard disabled"

input=$(cat)

# Only inputs that carry a command field pay the Node startup cost.
has_command=$(
    printf '%s' "$input" | jq -r '
  [ .. | objects | (.command? // empty, .cmd? // empty, .script? // empty) | strings ] | length > 0'
) || fail "failed to parse Vibe hook payload"
[ "$has_command" = "true" ] || exit 0

hook_cwd=$(printf '%s' "$input" | jq -r '.cwd // empty') || fail "failed to read cwd"
case "$hook_cwd" in
/*) ;;
*) fail "no absolute cwd; skipping command check" ;;
esac

# Build {commands:[{command,cwd}...]} with the same 64 KiB cap as maki.
payload=$(printf '%s' "$input" | jq -c --arg cwd "$hook_cwd" '
  .tool_input as $ti |
  { commands: [
      ($ti | .. | objects) |
      (.command? // empty, .cmd? // empty, .script? // empty) |
      strings | { command: ., cwd: $cwd }
    ] }') || fail "failed to encode commands"

payload_len=${#payload}
if [ "$payload_len" -gt 65536 ]; then
    # Oversize input: skip silently (the maki port warns only once; Vibe hook
    # failures would warn on every call, so this path stays quiet).
    exit 0
fi

# check.mjs prints one JSON decision and exits 0: the first deny,
# {kind:"allow"}, or {kind:"error"} on its own failure.
decision=$("$node_bin" "$CHECK_MJS" "$api" "$payload") ||
    fail "check failed or timed out"

kind=$(printf '%s' "$decision" | jq -r '.kind // empty') ||
    fail "bad decision JSON"
case "$kind" in
allow)
    exit 0
    ;;
deny)
    tool_name=$(printf '%s' "$input" | jq -r '.tool_name // "tool"') || fail "bad tool_name"
    # Build the final JSON with jq to keep the reason properly escaped.
    printf '%s' "$decision" | jq -c --arg tool "$tool_name" \
        '{decision: "deny", reason: ($tool + " is off limits: " + .reason)}' || fail "failed to encode denial"
    ;;
*)
    fail "analysis failed: $(printf '%s' "$decision" | jq -r '.reason // "unknown"')"
    ;;
esac
