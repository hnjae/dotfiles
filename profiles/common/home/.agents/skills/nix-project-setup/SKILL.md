---
name: nix-project-setup
description: Adapt a repository to the user's Nix development setup with .editorconfig, .envrc, justfile, and flake-parts partitions. Use when asked to apply the user's project template, match the limitping setup, introduce or reorganize Nix package builds, or centralize package checks, git-hooks.nix with prek, and treefmt-nix in a flake. Keep package builds independent of development-only inputs and adapt tools to the target language. Do not trigger for an isolated Nix error, dependency update, formatting request, or fork licensing/ownership transition.
compatibility: Git and Nix with flakes; direnv with nix-direnv for shell activation; language tools provided by the development shell.
---

# Nix Project Setup

Make the repository buildable and checkable through Nix, using the user's established separation between package consumers and development tooling. Treat the target's existing build, tests, supported platforms, and runtime behavior as contracts to preserve.

Read [the reference transition](references/limitping.md) for provenance and scope. Read [the flake pattern](references/flake-pattern.md) before implementing the flake. Use the bundled files in `assets/` as starting points, then adapt them to the target; they are not an overwrite script.

## 1. Inspect and choose the adaptation

Read applicable `AGENTS.md`, relevant intent docs, the working tree, language manifests and lockfiles, existing build definitions, formatter configuration, CI, and developer documentation. If a fork point is supplied, compare its setup files with the current state to understand the requested conventions; do not reproduce every intervening change.

Establish the package entry point, dependency locking and native libraries, real test/lint commands, supported systems, existing Nix outputs consumed elsewhere, and files with special indentation or formatting requirements. Preserve user edits and useful recipes. A request to assess the setup authorizes investigation; a request to apply it authorizes local changes.

Use the supplied template or reference when available. For this setup, prefer the bundled limitping-derived pattern over older templates that use a hook runner as `formatter` or place development-only imports in the main evaluation. Do not require access to the original repository after installation of this skill.

State consequential assumptions and verification before editing. Ask one focused question only when repository evidence cannot resolve a choice with materially different results, such as multiple deployable packages with no default. Infer the language and build tool from the repository rather than asking the user to restate them.

## 2. Separate package and development evaluation

Define the package build, development shell, checks, hooks, and formatting in the root `flake.nix`, using `flake-parts.lib.mkFlake`. Keep small setups inline; retain existing modules when they already provide a clear boundary. Do not split every definition into a new file just for consistency.

- Keep package-required inputs in root `inputs`: `nixpkgs`, `flake-parts`, and any actual builder inputs such as `crane`. Use `https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0` for a new nixpkgs input and make `flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs"`. Preserve an existing locked version unless changing it is needed for this task.
- Import `inputs.flake-parts.flakeModules.partitions`. Set `partitions.dev.extraInputsFlake = ./nix/partitions/dev` and put development imports and definitions under `partitions.dev.module`.
- Declare `git-hooks` and `treefmt-nix` only in `nix/partitions/dev/flake.nix`; import their `flakeModule` values only inside the dev partition. The subflake supplies inputs with `outputs = _: { };`, not a second set of package or check definitions. Its `follows` paths resolve within the subflake, so include its own nixpkgs input and use the same URL as the root. Keep input names consistent.
- Route `checks`, `devShells`, and `formatter` to `"dev"` with `partitionedAttrs`. Leave `packages` in the base evaluation. Package definitions must not depend on dev partition inputs, checks, hooks, or shells; consumers should not need development inputs to evaluate a package.
- Maintain both root `flake.lock` and `nix/partitions/dev/flake.lock`. Lock both using Nix, preserving unrelated pins. Never copy another project's hashes or fabricate a lockfile by hand.

Expose `packages.default` for a single main application; preserve existing named outputs and module exports. Select systems that the project can support, using the reference's Linux and Apple Silicon macOS list only when appropriate. Do not silently remove supported systems or claim untested platforms work.

Use the appropriate Nix builder for the existing ecosystem. Keep source selection, dependency hashes, executable names, flags, assets, native libraries, and runtime dependencies faithful to the target. Build-derived hashes must be computed for the target. Use `vendorHash = null` only when a Go module genuinely needs no vendored external dependencies; a temporary fake hash is a discovery tool, not a finished result.

## 3. Centralize formatting, hooks, and checks

In the dev partition, import both modules and set `treefmt.projectRootFile = "flake.nix"`. Let treefmt-nix provide `formatter` and its formatting check. Enable formatters for actual repository content: `nixfmt`, `rumdl-format`, `taplo`, `yamlfmt`, and `just` where those file types exist, plus the target language's formatter. For Go, use `gofmt`; for Rust, use `rustfmt`. Do not copy Go tools into a different-language repository or run a second formatter for the same files through hooks.

Use `pre-commit.settings.package = pkgs.prek`. Enable `treefmt`, `detect-private-keys`, and `typos` hooks. Use the reference's Cocogitto `commit-msg` hook for Conventional Commits. Enable `reuse` when the target already follows REUSE or the user separately requests its adoption; this setup alone does not authorize relicensing or mass SPDX edits. Keep existing applicable security and lint checks.

Define project test and static-analysis derivations in `checks` inside the dev partition. Preserve the effective coverage of existing CI, including race detection or integration tests where feasible; formatting hooks alone are not project tests. Give checks the compiler, fixtures, native libraries, and dependencies they actually need. Keep checks sandbox-compatible and offline after dependencies are fetched. Do not weaken a check to obtain a passing migration.

For Go with the reference's existing race/coverage contract, use a check build with `go vet ./...`, `CGO_ENABLED=1 go test -race -coverprofile=coverage.out -covermode=atomic ./...`, and `go tool cover -func=coverage.out`, with a C compiler available. Preserve `preCheck` and `postCheck` hooks in a custom phase. Keep the distributed package's CGO policy separate from its race test needs. For other languages, translate the intent to existing test/lint commands rather than copying these commands.

Construct `devShells.default` with language/build tools, `inputsFrom = [ config.treefmt.build.devShell ]`, and `config.pre-commit.settings.enabledPackages`. Use `mkShellNoCC` when a compiler is not needed; choose `mkShell` or add the needed compiler otherwise. Combine `config.pre-commit.shellHook` with a hook that exposes the generated treefmt config:

```sh
if [ ! -e treefmt.toml ] || [ -L treefmt.toml ]; then
  ln -sfn GENERATED_TREEFMT_CONFIG treefmt.toml
fi
```

Replace `GENERATED_TREEFMT_CONFIG` with `${config.treefmt.build.configFile}` inside the Nix string. Preserve a regular user-owned `treefmt.toml`; incorporate its effective settings into Nix and resolve any conflict before removing it. Do the same for an existing handwritten hook configuration. Commit the Nix source of truth, not generated symlinks.

## 4. Apply the companion files

Merge the bundled `.editorconfig` conventions into the target: UTF-8, LF, final newline, trimmed trailing whitespace, two-space Nix/YAML/TOML/JSON, and four-space Markdown/just/shell. Add language-specific sections such as tabs for Go or four spaces for Rust/Python. Preserve meaningful exceptions, including Makefile tabs and required Markdown hard-break whitespace.

Use `.envrc` to watch both lockfiles and activate `use flake "#default"`. Retain existing environment setup needed by the project, and watch extra local files only where necessary. Review the shell hook before running it because it installs local Git hooks and may generate symlinks. Do not run `direnv allow` unless the user explicitly requests trust/activation.

Use the bundled `justfile` conventions: executable-style shebang, `set unstable`, `set fallback := false`, `set lazy`, and a default recipe listing commands. Keep `format` as `nix fmt` and `build` as `nix build`; add language-appropriate test/lint recipes and a thin `nix flake check` recipe when useful. Preserve useful existing commands. Keep authoritative check definitions in Nix so CI and local commands agree.

Ignore root `/.pre-commit-config.yaml`, `/treefmt.toml`, and `/result*` when they are generated, plus `/.direnv/` when needed; preserve existing ignore rules. Add tool configuration only for tools that are actually enabled or already used. Apply narrowly justified typo exceptions; do not copy another project's exceptions. Do not add a blanket lint suppression or copy an unused `statix.toml`.

If the requested setup includes CI migration, use `nix flake check` as the entry point for the checks now defined in Nix. Preserve unrelated release, deployment, platform, and integration jobs; move their needed checks before removing duplicate commands. Use the applicable GitHub Actions hardening skill when editing a GitHub workflow, and resolve action versions from current primary sources rather than copying reference revisions.

Update existing README/contributor instructions with working build, shell, formatting, and check commands. Do not introduce intent-doc directories or change application behavior, license, fork ownership, branding, releases, or unrelated documentation as a side effect.

## 5. Verify and finish

Ensure all newly created Nix source files are visible to the flake. A Git flake excludes untracked files: stage only task-owned paths when permitted, or evaluate a disposable source copy with `path:`. Do not stage unrelated work just to make evaluation pass.

Lock the root and dev subflake. Run `nix build`, `nix fmt`, and `nix flake check` against the target, then inspect the diff for formatter changes outside scope. Check that all intended project checks, the hook check, and the formatting check exist in the dev output. Verify the development shell supplies the enabled tools and initializes hooks/config as intended; inspect existing local hooks first to preserve user work. Run the language's relevant existing tests if not already exercised by the flake checks.

Verify the package boundary independently: evaluate `packages.<system>.default.drvPath` with `nix eval`, and inspect the root lock graph for development-only inputs. For a stronger check, use a disposable copy with the dev input directory unavailable and evaluate the package there; do not rename or delete files in the user's working tree. Successful `nix flake show` alone does not establish this boundary, because it traverses development outputs too.

Check `just --list`, the effective EditorConfig language sections, and that a second application would produce no duplicates or cosmetic churn. If the setup already satisfies the request, leave it unchanged and report the checks performed.

Report exact commands that passed and any commands that could not run, including network, sandbox, or platform limitations. Do not substitute evaluation success for build/test success. Follow the target's commit policy, use `git-commit` when committing, and stage only task-owned changes. Keep one coherent migration with its documentation and checks; do not push or publish without authorization.
