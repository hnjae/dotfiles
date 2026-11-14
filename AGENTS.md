# Agent Guidelines

- **No backward compatibility**: This repo has one user. Make clean breaks; skip migrations, shims, and legacy support unless explicitly requested.
- **Profile directory names**: Under `profiles/<profile>/`, a link source is named `<anchor>[+<subpath>][@<mode>]`.
    - Its children are symlinked into the target by a `glob: true` entry in that profile's `install.conf.yaml`, so adding a child needs no yaml edit.
    - `anchor` is `home`, `xdg-config-home`, `xdg-data-home`, or `xdg-bin-home`. `subpath` is the path below the anchor with `/` written as `+`, keeping dots literal (`home+.omp+agent` → `~/.omp/agent`).
    - `@seed` copies instead of linking. A directory starting with `_` is not a link source (`_install` holds scripts run by `install.conf.yaml`).
    - Use a dedicated directory only where the target must stay a real directory (it holds runtime files). Otherwise link the whole directory as a child of its anchor.
- **Agent skills**: third-party and authored skills share one store, `~/.agents/skills/`, and differ by ownership:
    - Authored skills live in `profiles/common/home+.agents+skills/<name>/` and are linked into the store by dotbot.
    - Third-party skills are pinned in `profiles/common/home+.agents/skills.toml` (live: `~/.agents/skills.toml`): one block per repository with a commit hash, a skill list, and optionally a `path` for repositories whose skills live outside the discoverable layout. Never commit their content.
    - `profiles/common/_install/agent-skills.py` owns everything else: `restore` fetches each block at its commit and prunes pool directories the manifest dropped, `sync` applies the exposure list, `pool` lists unexposed skills, `verify` checks that manifest, pool, and exposure agree.
    - The store is the pool: everything in it is visible to pi. `~/.claude/skills/` is a subset chosen by `profiles/common/home+.agents/claude-skills.txt` (live: `~/.agents/claude-skills.txt`) and applied by `agent-skills.py sync`. Nothing else writes links there.
    - Keep the store flat at the top level: one directory per skill, `SKILL.md` at `<store>/<name>/SKILL.md`. Claude Code does not recurse, so bucket directories hide their skills from it. (`~/.claude/skills/synced/` is Claude's own account bucket; leave it alone.)
    - Add a skill with `agent-skills.py add <owner/repo> -s <name> [--ref <tag>]`, which installs it and appends the block; bump a repository with `agent-skills.py update [<owner/repo>]` followed by `restore`. Never reuse an authored skill's name: the store is flat and the manifest rejects collisions.
