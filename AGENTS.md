# Agent Guidelines

This repo has one user, so make clean breaks: skip migrations, shims, and legacy support unless explicitly requested.

## Profile directory names

Under `profiles/<profile>/`, a link source is named `<anchor>[+<subpath>][@<mode>]`.

- Its children are symlinked into the target by a `glob: true` entry in that profile's `install.conf.yaml`, so adding a child needs no yaml edit.
- `anchor` is `home`, `xdg-config-home`, `xdg-data-home`, or `xdg-bin-home`. `subpath` is the path below the anchor with `/` written as `+`, keeping dots literal (`home+.omp+agent` → `~/.omp/agent`).
- `@seed` copies instead of linking. A directory starting with `_` is not a link source (`_install` holds scripts run by `install.conf.yaml`).
- Give a target its own link source only when the target must stay a real directory because programs write runtime files into it (`home+.agents+skills/` → `~/.agents/skills/`, where `agent-skills.py restore` installs third-party skills). Otherwise put the directory under its anchor so the whole directory is one symlink (`xdg-config-home/nvim/` → `~/.config/nvim`).

## Install scripts

Anything under `profiles/<profile>/_install/` runs on every `install.sh` and `just update-dotfiles`, so it must be idempotent. A second run with nothing to do changes no file, link, or state, and reports that nothing changed instead of rewriting: compare before writing, and make a removal conditional on what is actually there.

## Agent skills

Third-party and authored skills share one store, `~/.agents/skills/` (the pool), and differ by ownership:

- Authored skills live in `profiles/common/home+.agents+skills/<name>/` and are linked into the store by dotbot.
- Third-party skills are pinned in `profiles/common/home+.agents/skills.toml` (live: `~/.agents/skills.toml`): one block per repository with a commit hash, a skill list, and optionally a `path` for repositories whose skills live outside the discoverable layout. Never commit their content: the pinned commit is the record, and `restore` refetches the content from it.
- `profiles/common/_install/agent-skills.py` owns everything else: `restore` fetches each block at its commit and prunes pool directories the manifest dropped, `sync` applies the exposure list, `pool` lists unexposed skills, `verify` checks that manifest, pool, and exposure agree.
- Everything in the store is visible to pi (the pi coding agent). `~/.claude/skills/` is a subset chosen by `profiles/common/home+.agents/claude-skills.txt` (live: `~/.agents/claude-skills.txt`) and applied by `agent-skills.py sync`. Nothing else writes links there: to expose a skill to Claude Code, add it to that list and run `sync` instead of linking by hand.
- Keep the store flat at the top level: one directory per skill, `SKILL.md` at `<store>/<name>/SKILL.md`. Claude Code does not recurse, so bucket directories hide their skills from it. (`~/.claude/skills/synced/` is Claude's own account bucket; leave it alone.)
- Add a skill with `agent-skills.py add <owner/repo> -s <name> [--ref <tag>]`, which installs it and appends the block; bump a repository with `agent-skills.py update [<owner/repo>]` followed by `restore`. Never reuse an authored skill's name: the store is flat and the manifest rejects collisions.

## Licensing

The repo is `AGPL-3.0-or-later` and REUSE-compliant; the `reuse lint` pre-commit hook rejects a file with no license information. The `reuse-compliance` skill holds the full rules.

- Declare license information closest to the file: an SPDX header (license line first, copyright lines directly after with no spacer line, `2026 KIM Hyunjae`), else a `<file>.license` sidecar, else a glob in the default table of `REUSE.toml`, which is only for formats that cannot hold a header. Do not put license identifiers anywhere else in `REUSE.toml`.
- Put a header below shebangs and first-line directives (`# shellcheck shell=`, `--- @sync entry`, modelines). Never put one in JSON, frontmatter, generated files, or files an application rewrites: the comment would break parsing or be lost on the next rewrite.
