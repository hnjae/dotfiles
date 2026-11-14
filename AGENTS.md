# Agent Guidelines

- **No backward compatibility**: This repo has one user. Make clean breaks; skip migrations, shims, and legacy support unless explicitly requested.
- **Profile directory names**: Under `profiles/<profile>/`, a link source is named `<anchor>[+<subpath>][@<mode>]`.
    - Its children are symlinked into the target by a `glob: true` entry in that profile's `install.conf.yaml`, so adding a child needs no yaml edit.
    - `anchor` is `home`, `xdg-config-home`, `xdg-data-home`, or `xdg-bin-home`. `subpath` is the path below the anchor with `/` written as `+`, keeping dots literal (`home+.omp+agent` → `~/.omp/agent`).
    - `@seed` copies instead of linking. A directory starting with `_` is not a link source (`_install` holds scripts run by `install.conf.yaml`).
    - Use a dedicated directory only where the target must stay a real directory (it holds runtime files). Otherwise link the whole directory as a child of its anchor.
- **Agent skills**: third-party and authored skills share one store, `~/.agents/skills/`, and differ by ownership:
    - Authored skills live in `profiles/common/home+.agents+skills/<name>/` and are linked into the store by dotbot.
    - Third-party skills are pinned in `profiles/common/home+.agents/skills-lock.json` (live: `~/.agents/skills-lock.json`) and restored by `_install/agent-skills.sh restore`. Never commit their content.
    - The store is the pool: everything in it is visible to pi. `~/.claude/skills/` is a subset chosen by `profiles/common/home+.agents/claude-skills.txt` (live: `~/.agents/claude-skills.txt`) and applied by `_install/agent-skills.sh sync`. Nothing else writes links there.
    - Keep the store flat at the top level: one directory per skill, `SKILL.md` at `<store>/<name>/SKILL.md`. Claude Code does not recurse, so bucket directories hide their skills from it. (`~/.claude/skills/synced/` is Claude's own account bucket; leave it alone.)
    - Add or update a skill only through `profiles/common/_install/agent-skills.sh add <owner/repo> -s <name> -y`, which installs from the tracked lock's directory and records the entry there. Use a `.../tree/<ref>/<path>` source when the skill sits outside the repo's discoverable layout, and never reuse an authored skill's name.
