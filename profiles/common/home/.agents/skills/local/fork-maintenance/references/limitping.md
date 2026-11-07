# Reference: limitping fork transition

This example records the intent of two commits in `hnjae/limitping`. Use it to recognize coupled licensing and infrastructure changes, while deriving names, notices, and licenses from each target repository.

## Source history

- Fork point: `6052828a5e595e0918206b927d875384e7c85dd1`.
- `947ab60`: `docs(license): adopt AGPL-3.0-or-later with REUSE`.
- `f47fb5a`: `fix(fork): use fork-owned module and releases`.

Upstream was `wavever/CCLimitPing`, distributed under MIT. The fork was `hnjae/limitping`, adopting `AGPL-3.0-or-later`. Existing upstream copyright was preserved, with `KIM Hyunjae` added for fork contributions where applicable.

## Licensing outcome

`LICENSE.md` states the fork's AGPL license, identifies the upstream project, and reproduces the original MIT copyright, permission notice, and disclaimer. `LICENSES/AGPL-3.0-or-later.txt` contains the outbound license text. Source and configuration files carry SPDX information; `REUSE.toml` supplies annotations for files such as `go.sum` and GitHub Markdown templates.

The release archive includes `LICENSE.md` and the AGPL text. Its file list therefore follows the license document's rename. An original MIT notice inside `LICENSE.md` travels with the archive without implying that the complete fork has an optional MIT license.

## Infrastructure outcome

| Coupled changes                                                  | Result                                                                                                   |
| ---------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| `go.mod`, internal imports, and GoReleaser linker paths          | All use `github.com/hnjae/limitping`.                                                                    |
| Installer, update API, upgrade downloads, and release-note links | All resolve fork releases from `hnjae/limitping`.                                                        |
| GoReleaser and release workflow                                  | Releases target the fork; upstream Homebrew publishing and its token reference are removed.              |
| README badges, source installation, and security reporting       | Operational links target the fork, with explicit upstream attribution retained.                          |
| Installation documentation before the first fork release         | Source builds are usable; binary installs and module-tag installs state their publication prerequisites. |

## Lessons to reuse

Change identifiers and all their consumers together. A module rename without linker-path updates breaks version injection; a license-file rename without archive updates loses the notice from distribution. Inspect the resulting configuration rather than copying individual edits mechanically.

The first licensing commit still named the old root license path in the archive configuration. The second commit corrected that path and removed a reference to a nonexistent MIT text file. For a new transition, keep packaging consistent in the licensing change itself.

This example also deleted a translated README, branding assets, and upstream `AGENTS.md`, and added a formatter setting. Those are repository-specific choices. They are not part of the reusable fork transition unless separately requested or required.
