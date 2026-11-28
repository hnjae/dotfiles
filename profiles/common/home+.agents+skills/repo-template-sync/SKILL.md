---
name: repo-template-sync
description: "Bring a repository in line with the author's shared tooling template (prek, treefmt, rumdl, taplo, cog, typos, editorconfig, direnv, Nix dev shell): set it up in a new repository, or review an existing one against the template and apply the differences the user approves. Use when setting up tooling in a repository, when asked to sync, update, or check a repository against the template, or after editing the template itself. Not for REUSE licensing (use reuse-compliance)."
---

# Repo Template Sync

The templates in `templates/` are the single source of truth for the tooling every repository shares. A repository gets only the parts it needs. The repository keeps no state about the template: each run compares the repository with the current template, and the user approves every change before it is applied.

REUSE (`reuse` hook, `REUSE.toml`, SPDX headers) is out of scope: leave it as it is and use `reuse-compliance`.

## Template layout

`templates/<dir>/<target path>.tmpl` renders to `<target path>` in the repository root. Which directories apply:

| Directory | Applies | Contents |
| --- | --- | --- |
| `core` | always | `prek.toml`, `treefmt.toml`, `.editorconfig`, `rumdl.toml`, `taplo.toml`, `cog.toml`, `typos.toml`, `statix.toml`, `.envrc` |
| `shell-nix` | env is `shell-nix` | `shell.nix` |
| `biome` | module `biome` | `biome.json` |
| `yamlfmt` | module `yamlfmt` | `yamlfmt.yaml` |
| `python` | module `python` | `ruff.toml` |
| `lua` | module `lua` | `stylua.toml` |

Shared files carry every module's settings. A block wrapped in `# >>> <tag>` and `# <<< <tag>` lines (marker alone on its line, no nesting) belongs to that tag. To render, keep a block's content when its tag is enabled, drop the block when it is not, delete every marker line, and copy the rest verbatim. Tags are the module names plus the env (`shell-nix`, `flake`, or `devenv`). Template files hold no license header, so rendered files get none.

## Opt-in modules

Enable a module when `git ls-files` shows a matching tracked file. Ignore the module's own config file and files the repository deliberately keeps out of formatting (test fixtures, vendored or generated code); ask when unsure.

| Module | Trigger |
| --- | --- |
| `biome` | `*.js *.jsx *.ts *.tsx *.mjs *.cjs *.mts *.cts *.json *.jsonc *.css` |
| `yamlfmt` | `*.yaml *.yml` |
| `python` | `*.py *.pyi` |
| `lua` | `*.lua` |

Everything else is core and always on, including taplo. The environment is `devenv` when the repository has `devenv.nix` or `devenv.yaml`, even alongside `flake.nix`, because devenv then owns the dev shell. Otherwise it is `flake` when the repository has `flake.nix`, then `shell-nix` when it has `shell.nix`; if it has none of these, ask.

## Environment contract

The tool list lives in one place, the `packages` list of `shell-nix/shell.nix.tmpl`, embedded in the dev shell itself. The dev shell must contain every package of the rendered list, together with the repository's own packages in the same list, and run `prek install --quiet` when it starts (`shellHook`; `enterShell` in devenv).

`shell.nix` is a starting point for new `shell-nix` repositories; an existing one keeps its own structure and only gains the missing packages and the hook. A `flake` repository creates no `shell.nix`: render the same template for its list and hook, and put them in the devShell of its own `flake.nix`:

```nix
devShells.default = pkgs.mkShellNoCC {
  packages = with pkgs; [
    # rendered list, plus the repository's own packages
  ];
  shellHook = ''
    prek install --quiet
  '';
};
```

Where the devShell goes in a flake repository:

- An existing devShell keeps its place and structure: add to it.
- With flake-parts partitions, it sits under `partitions.dev.module` (`perSystem`, `devShells.default`).
- With flake-parts but no partitions, it is `devShells.default` in `perSystem`.
- In a plain flake, it is `devShells.<system>.default`.
- When adding it would make `flake.nix` large, create `nix/`, split the flake into files there, and import them from `flake.nix`.

A `devenv` repository creates no `shell.nix` and adds no devShell to `flake.nix`: render the same template, add the list to `packages` in the `devenv.nix` that defines the shared shell (follow `imports` in `devenv.yaml` to find it), and put `prek install --quiet` in `enterShell`.

## Justfile contract

`justfile` is repository-owned and every repository has one (a missing one is a difference: create it). It must provide these recipes. The body states the required effect; the repository may add its own steps, which is why no template file exists for it (`import` rejects a recipe defined twice, so a repository could not extend an imported one).

```just
[group('tooling')]
format:
    treefmt

[group('tooling')]
lint:
    prek validate-config prek.toml
    prek run --all-files
    prek run --all-files --hook-stage manual

[group('tooling')]
ci: lint
```

- `format` rewrites files with `treefmt`.
- `lint` runs every checker the dev shell installs: every hook of both stages (`pre-commit` and `manual`), the hook config check, and the repository's own linters and type checks (not tests).
- For every linter or analyzer in the list, name the hook or `lint` step that runs it, and check the mode. A formatter rewrites files and does not check: `treefmt` runs `ruff format`, so `ruff check` needs its own hook or `lint` step. One whose only reachable mode is formatting, or that no command reaches, is a difference.
- `ci` is what CI runs: `lint`, plus tests and any other check.
- The repository may split `lint` into smaller recipes (a `typecheck` that `lint` depends on) as long as `lint` still has the whole effect.

A recipe with one of these names but another meaning (a `lint` that runs only project linters) is a difference. Recommend adding the missing effect to it instead of renaming it.

## Hook stages

The `pre-commit` hook runs on every commit, so it holds only checks that are fast on staged files: formatting, whitespace, typos, secrets, and the quick linters the template ships. A repository's slow checks (type checkers, whole-project analysis) get `stages = ["manual"]`, so a commit never waits for them and `lint` still runs them.

## Sync

1. Detect the env and modules.
2. Render every applicable template for comparison only, in your scratch space or in memory. Nothing in the repository changes before step 6, because the user approves every change first.
3. Compare each rendered file with the repository's file. A missing file is one difference. Compare shared files entry by entry: for every formatter in `treefmt.toml` and every hook in `prek.toml` that the template ships, find the repository's entry by its command (the name may differ). A missing entry, or one whose name, options, `includes`, or `priority` differ, is a difference, even when the two seem to behave the same (an alias such as `taplo format` for `taplo fmt`). Also check the environment and justfile contracts (including a reachable checking command for every installed linter or analyzer), and look for legacy files, retired tools, and obsolete installers listed under "Applying" below.
4. Sort what you find:
    - Local customization: settings the repository has and the template lacks (extra treefmt formatters and prek hooks, excludes, typos words, taplo rules, project packages). Keep them and do not report them. Two exceptions, both reported as differences: a retired tool, and a `treefmt.toml` formatter that only checks and never rewrites (`shellcheck`, `ruff check` without `--fix`). A checking formatter makes `treefmt` fail on a warning, which breaks the `format` recipe, and the checking hook already covers it. Recommend removing it, after confirming a prek hook or `lint` step runs the tool's checking mode (recommend adding that hook when none does).
    - Difference: everything else, such as a value that conflicts, a template block the repository lacks, a missing file, a legacy file, or a tool the repository adds whose package is missing from the dev-shell `packages` list.
5. Show the user the differences in one review, grouped by file. For each, give the repository's value, the template's value, and a recommendation (almost always "take the template"; "keep the repository's" when the difference is clearly project-specific). When the user asks only to check, stop here.
6. Apply only what the user approves, following the rules below. Leave the rest untouched.
7. Verify.

<example>
`treefmt.toml`

- `walk`: repository `"filesystem"`, template `"git"`. Recommend: take the template.
- `[formatter.yamlfmt]`: repository lacks it, template has it (`yamlfmt` module on). Recommend: take the template.

`.editorconfig-checker.json`

- Retired tool `editorconfig-checker`. Recommend: delete it, along with its prek hook and dev-shell package.
</example>

A difference the user has declined will come up again on the next run: that is expected, so do not try to remember it.

## Applying

- Keep a hook's `stages`, and set `default_install_hook_types` to the template's types plus every stage a kept hook uses (a local `pre-push` hook needs `pre-push`).
- A path the repository keeps out of one tool (test fixtures, vendored code) must stay out of every hook and formatter the template adds: put it in prek's top-level `exclude` as well as in the formatter's `excludes`.
- Keep existing license information as it is: an SPDX header goes below a shebang or first-line directive, and JSON takes a `<file>.license` sidecar. In a repository that uses REUSE, give every new file license information the same way, following `reuse-compliance`; elsewhere add none. Leave an existing `reuse` hook alone.
- Legacy names move without leaving a shim: `.pre-commit-config.yaml` to `prek.toml` (translated to TOML), `.rumdl.toml` to `rumdl.toml`, `biome.jsonc` to `biome.json`. Commit-msg checking moves into the `cog-verify` prek hook and any `[git_hooks]` table leaves `cog.toml`. Once a legacy file's content is in its new file, delete the legacy file, and remove obsolete installers (a justfile `hooks-install` recipe, `cog install-hook`) along with references to them.
- Retired tools are never removed on their own: report each place one appears as a difference and remove only what the user approves. `editorconfig-checker` is retired (its prek hook, justfile steps, dev-shell package, and `.editorconfig-checker.json`); the `end-of-file-fixer` hook replaces it.
- `git-hooks.nix` and `treefmt-nix` migrate to `prek.toml` and `treefmt.toml`. The migration covers the flake modules (including a `git-hooks.nix` or `treefmt.nix` file under `nix/`), their flake inputs, a `shellHook` taken from them, and a `formatter` output built from them. This rewrites the flake, so propose it as a difference of its own and apply it only on approval. Once approved:
    1. Translate every enabled hook and formatter into the template's hooks and formatters; what the template lacks becomes a local entry.
    2. Remove the modules and inputs.
    3. Run `nix flake lock` so the lock file drops the inputs.
    4. Point a `formatter` output at `pkgs.treefmt`.
- In a `devenv` repository, the same tools come from devenv's `git-hooks` and `treefmt` options, with their inputs in `devenv.yaml`, and they generate `.pre-commit-config.yaml` and `treefmt.toml` (often gitignored). Compare the generated files, but treat them as legacy output, not as the repository's own config. The migration is the same difference of its own, with these changes: remove the options and inputs, run `devenv update` instead of `nix flake lock` so `devenv.lock` drops the inputs, and remove the generated files from `.gitignore` so the new `prek.toml` and `treefmt.toml` are tracked.
- Make the dev shell meet the environment contract: add the missing template packages to its `packages` list and keep the repository's own entries. If `.git/hooks/` holds hook scripts that prek did not write (left by pre-commit, git-hooks.nix, or `cog install-hook`), run `prek install --force` once, because a plain `prek install` keeps the old hooks running alongside its own.

## Verify

Run each check and report its result. A check that failed to start does not count as passing; when one cannot run, say which and why.

1. In a `flake` repository, check the dev shell: `git add` new files (flakes ignore untracked ones), then run `nix develop --command sh -c 'for c in <executables>; do command -v "$c" >/dev/null || echo "missing: $c"; done'` with the executable of every package in the rendered list (`cocogitto` provides `cog`). It must print nothing. In a `devenv` repository, run the same loop with `devenv shell -- sh -c '...'`.
2. Run `prek validate-config prek.toml`, `prek run --all-files`, and `prek run --all-files --hook-stage manual`, inside `nix develop` for a flake repository and `devenv shell` for a devenv repository. Report failures that existing repository content causes (for example formatting the new treefmt config would change) instead of fixing unrelated files.
3. Repeat Sync steps 1–4. Only the differences the user declined may remain.

## Editing the template

Edit the files in this skill's own `templates/` directory. The skill directory is a symlink into the dotfiles repository, so the edits land in that repository wherever it is checked out; commit them there. Keep settings generic: no project paths, no license headers. Add a tool by putting its settings in the shared files under a tag (or a new directory for a whole file) and its package in the `shell-nix/shell.nix.tmpl` list. When the tool checks files, add a hook that runs its checking mode; a formatter entry in `treefmt.toml` does not cover it. Then update the tables above.
