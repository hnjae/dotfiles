#!/bin/sh

# The skills CLI resolves both its lock file and `.agents/skills` relative to
# the working directory, with no flag to point either somewhere else. Stage a
# throwaway project root that symlinks both at the real locations, so the
# tracked lock can live next to the store at ~/.agents/skills-lock.json.
#
# Authored skills are linked by dotbot and never touched here: restore skips
# any entry whose directory already holds a SKILL.md. Claude Code keeps its own
# skills directory, because `synced/` there is its account bucket, so installed
# skills are mirrored into it one link each.

set -eu

lock="${HOME}/.agents/skills-lock.json"

if [ ! -f "$lock" ]; then
    printf 'no skill lock at %s, skipping\n' "$lock" >&2
    exit 0
fi

project="${XDG_CACHE_HOME:-${HOME}/.cache}/agent-skills"
mkdir -p "${project}/.agents"
ln -sfn "${HOME}/.agents/skills" "${project}/.agents/skills"
ln -sfn "$lock" "${project}/skills-lock.json"
cd "$project"

command="${1:-restore}"
if [ "$#" -gt 0 ]; then
    shift
fi

# `--agent universal` comes last: the flag is variadic, so anything positional
# after it would be swallowed as an agent name.
case "$command" in
restore)
    bunx skills@1.8 experimental_install "$@" --agent universal
    ;;
add)
    exec bunx skills@1.8 add "$@" --agent universal
    ;;
*)
    printf 'usage: %s [restore|add <args>]\n' "$0" >&2
    exit 2
    ;;
esac

claude_skills="${HOME}/.claude/skills"
mkdir -p "$claude_skills"

for dir in "${HOME}/.agents/skills"/*/; do
    name="$(basename "$dir")"
    # Authored skills are symlinks in the store, and dotbot owns their links.
    if [ -L "${dir%/}" ]; then
        continue
    fi
    # Leave existing entries alone, including Claude's own.
    if [ -e "${claude_skills}/${name}" ] || [ -L "${claude_skills}/${name}" ]; then
        continue
    fi
    ln -sfn "${dir%/}" "${claude_skills}/${name}"
done
