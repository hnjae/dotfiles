#!/bin/sh

# The skills CLI resolves both its lock file and `.agents/skills` relative to
# the working directory, with no flag to point either somewhere else. Stage a
# throwaway project root that symlinks both at the real locations, so the
# tracked lock can live next to the store at ~/.agents/skills-lock.json.
#
# `~/.agents/skills/` is the installed pool. `~/.claude/skills/` is a subset
# chosen by ~/.agents/claude-skills.txt, because Claude Code does not scan the
# pool itself and pi would otherwise see every skill Claude syncs from its
# account. Authored skills are symlinks in the pool, put there by dotbot.

set -eu

store="${HOME}/.agents/skills"
lock="${HOME}/.agents/skills-lock.json"
exposed="${HOME}/.agents/claude-skills.txt"
claude="${HOME}/.claude/skills"

if [ ! -f "$lock" ]; then
    printf 'no skill lock at %s, skipping\n' "$lock" >&2
    exit 0
fi

command="${1:-restore}"
if [ "$#" -gt 0 ]; then
    shift
fi

# `--agent universal` comes last: the flag is variadic, so anything positional
# after it would be swallowed as an agent name.
cli() {
    project="${XDG_CACHE_HOME:-${HOME}/.cache}/agent-skills"
    mkdir -p "${project}/.agents"
    ln -sfn "$store" "${project}/.agents/skills"
    ln -sfn "$lock" "${project}/skills-lock.json"
    cd "$project"
    bunx skills@1.8 "$@"
}

# Link every listed skill and drop links that are no longer listed. Only
# symlinks are removed, so Claude's own account bucket survives.
sync_claude() {
    if [ ! -f "$exposed" ]; then
        printf 'no exposure list at %s, skipping\n' "$exposed" >&2
        return 0
    fi
    mkdir -p "$claude"

    while IFS= read -r name || [ "$name" != "" ]; do
        case "$name" in '' | '#'*) continue ;; esac
        if [ ! -f "${store}/${name}/SKILL.md" ]; then
            printf 'skip %s: not in the store\n' "$name" >&2
            continue
        fi
        ln -sfn "${store}/${name}" "${claude}/${name}"
    done <"$exposed"

    for path in "$claude"/*; do
        [ -L "$path" ] || continue
        name="${path##*/}"
        if ! grep -Fqx -- "$name" "$exposed"; then
            rm -- "$path"
        fi
    done
}

# Installed but not exposed, grouped by source.
show_pool() {
    python3 - "$lock" "$exposed" <<'PY'
import json
import pathlib
import sys

lock = json.loads(pathlib.Path(sys.argv[1]).read_text())
path = pathlib.Path(sys.argv[2])
lines = path.read_text().splitlines() if path.exists() else []
listed = {
    line.strip()
    for line in lines
    if line.strip() and not line.startswith("#")
}
by_source = {}
for name, entry in sorted(lock["skills"].items()):
    if name not in listed:
        by_source.setdefault(entry["source"], []).append(name)
if not by_source:
    print("every locked skill is exposed")
for source, names in sorted(by_source.items()):
    print(f"{source}: {' '.join(names)}")
PY
}

case "$command" in
restore)
    cli experimental_install "$@" --agent universal
    sync_claude
    ;;
add)
    cli add "$@" --agent universal
    ;;
sync)
    sync_claude
    ;;
pool)
    show_pool
    ;;
*)
    printf 'usage: %s [restore|add <args>|sync|pool]\n' "$0" >&2
    exit 2
    ;;
esac
