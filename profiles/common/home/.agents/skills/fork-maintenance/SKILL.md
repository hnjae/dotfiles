---
name: fork-maintenance
description: Prepare a fork for independent maintenance by adopting AGPL-3.0-or-later by default, or another license explicitly requested by the user, preserving upstream license obligations, and moving modules, installation, updates, and releases to fork ownership. Use when asked to take over maintenance of a fork, change its license, introduce REUSE, or make its distribution infrastructure fork-owned. Stop on license conflicts. Ordinary upstream syncs and unrelated release work are outside this scope.
---

# Fork Maintenance

Turn an upstream project into an independently maintained fork. The default outbound license is `AGPL-3.0-or-later`; an explicit request for another license takes precedence. Preserve the rights, notices, and obligations attached to inherited material throughout the transition.

Read [the reference transition](references/limitping.md) when an example would help. Its repository names, language, file deletions, and commit count are examples, not defaults for other projects.

## 1. Establish the target and scope

Read repository instructions and relevant `docs/spec/` and `docs/architecture/` files when present. Inspect the working tree, remotes, manifests, license files, file headers, installer, updater, and release configuration before editing. Use `rg` for searches.

Establish these facts from the request and repository:

- Upstream repository and identity, plus the fork point when available.
- Fork owner, repository, module or package identity, and release destination. A GitHub namespace does not establish ownership of an npm package, registry account, or Homebrew tap.
- Maintainer copyright identity and contribution years, supported by existing notices, history, or user input.
- Requested outbound license, defaulting to the exact SPDX identifier `AGPL-3.0-or-later`.
- Existing publication channels and whether the fork has its own usable releases or package versions.

Ask one focused question if a consequential fact cannot be established. Describe the intended license and identity changes before editing. A request for an assessment authorizes investigation; a request to perform the transition authorizes local implementation. Keep existing user changes intact.

## 2. Resolve licensing before making changes

Read the actual upstream license text, copyright notices, file-level exceptions, and bundled third-party licenses. Inspect dependencies that are incorporated into the distributed or hosted work; distinguish them from separate tools and remote services. Package metadata alone is insufficient evidence of licensing permission.

Determine whether the requested outbound license is permitted for the fork and compatible with the inherited material and relevant dependencies. Check the exact license versions, `-only` versus `-or-later`, exceptions, and any real choice of alternative licenses. Do not assume that every open source license permits conversion to the target.

**If a conflict exists, stop the transition before editing any files.** Report the affected material, original license, requested license, and conflicting requirement. Ask the user to resolve the conflict; do not silently select another target, drop the material, or proceed with the ownership changes. If permission or compatibility cannot be established, pause at the same gate and state what evidence is missing. When compatibility is established, proceed without asking for another generic confirmation.

Changing the fork's outbound license does not transfer upstream copyright or erase upstream grants. Preserve all required copyright notices, permission notices, license texts, disclaimers, attribution, and other conditions. Do not suggest that already released upstream material loses its original license.

For MIT material, keep the upstream copyright notice and the complete permission notice, including the disclaimer. Reproducing the original license in the root licensing document is a valid preservation approach; a link alone is insufficient. Include that document wherever copies or substantial portions of the material are distributed. A retained MIT notice documents inherited obligations; it does not by itself offer the entire fork under MIT as an alternative to the selected outbound license.

For other licenses, derive the preservation requirements from their actual terms. Keep required NOTICE material, modification notices, source availability, and license-specific distribution conditions where applicable. Consult primary license texts and authoritative guidance when needed; never invent permission to resolve uncertainty.

## 3. Introduce the target license and REUSE

Use existing repository conventions where they satisfy the intended licensing. Make the following changes together so documentation and distribution remain consistent:

- Add the complete target license text at `LICENSES/<SPDX-identifier>.txt`, using `reuse download <SPDX-identifier>` or an authoritative source. Keep a root licensing document that clearly states the fork's outbound license, identifies upstream provenance, and carries required original notices. Preserve custom license texts without replacing them with a generic template.
- Associate accurate `SPDX-FileCopyrightText` and `SPDX-License-Identifier` information with covered files. Preserve upstream holders and years. Add the maintainer to new or genuinely modified work according to repository policy; do not assign them copyright over every inherited file merely because the project was forked.
- Prefer comment headers where the file format permits them. Preserve shebangs, encoding declarations, and compiler directives in their required positions. Use `.license` companions or narrowly scoped `REUSE.toml` annotations for binaries, strict formats, generated files, and lockfiles where headers would be inappropriate.
- Preserve licenses and notices for third-party files, assets, and snippets. Apply the target license to fork material only where the licensing analysis permits it. Do not indiscriminately overwrite every SPDX identifier or introduce `OR` expressions that offer an unauthorized alternative license.
- Update license metadata, badges, documentation links, and release archive contents immediately. Every license text and notice required by shipped material must accompany its distribution; moving a notice from `LICENSE` to `LICENSE.md` requires updating archive manifests and every live reference.

Use `REUSE.toml` version 1 when annotations are needed. Inspect existing annotations before adding more: `*` does not cross directory separators, `**` does, and the last matching table in one file wins. The default `closest` behavior preserves file-level information; `aggregate` adds information, while `override` replaces closer information. Choose deliberately and never use broad overrides to conceal third-party licensing. Preserve one coherent annotation scheme; do not leave both `REUSE.toml` and `.reuse/dep5` active.

Keep `LICENSES/` for licenses actually referenced by covered files. When an original license is retained solely as a preservation notice, carry it in the root licensing document or another appropriate notice file. A license still applied to inherited or third-party files also needs its corresponding text in `LICENSES/`.

## 4. Move project infrastructure to fork ownership

Inventory upstream references by their purpose before replacing them. Move operational destinations to the fork. Preserve upstream provenance, copyright attribution, required notices, and references to independent dependencies.

| Surface                     | Required transition                                                                                                                                                                                                                              |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Module and package identity | Update the project's manifest identity, its internal imports, install commands, and build metadata such as Go linker symbol paths. Respect ecosystem rules and confirm registry identities when needed.                                          |
| Installation and updates    | Point installer scripts, release queries, asset downloads, update notices, and release-note links to the fork. Keep archive naming and platform selection consistent with its build configuration.                                               |
| Release publishing          | Update release owner/repository, registry or image destinations, and related workflow configuration. Remove or disable inherited publishing integrations the fork does not own, along with their now-unused secret references and documentation. |
| Repository support          | Update CI/release badges, homepage and repository metadata, issue links, security-report links, and support contacts that are intended to serve this fork.                                                                                       |
| User documentation          | Describe working fork installation and maintenance paths. Retain clear upstream attribution and explain any publication prerequisites.                                                                                                           |

Keep the existing executable name, commands, configuration paths, data formats, and runtime behavior unless a requested identity change requires otherwise. Do not bulk-replace an upstream owner's name in legal notices or change unrelated dependencies.

If the fork has no usable release or package version, provide a working source-build path and clearly identify release-based commands as requiring a future fork publication. Inherited tags alone do not prove that fork binaries exist. Never make installation or updates silently fall back to upstream artifacts. Treat a missing fork release as unavailable, using the project's existing failure behavior.

Do not invent a replacement Homebrew tap, registry, credential, or publishing service. Remove or disable an unsupported upstream integration instead. Delete orphaned configuration resulting from these changes. Keep translations, branding assets, and agent instructions unless the user requests their removal or their contents must be updated for the transition.

## 5. Finish according to the requested scope

Update existing intent docs when the transition changes their contracts or architecture; do not create `docs/spec/` or `docs/architecture/` merely for this task. Repeated execution should complete missing work without duplicating notices, headers, annotations, or release configuration. If the transition is already complete, report that state without creating cosmetic changes.

When verification is authorized, run `reuse lint`, relevant existing build/tests, and the release tool's local validation or snapshot mode where available. Examine produced archives for required licensing material. Search for remaining upstream operational destinations and stale file references, classifying intentional provenance references separately. Avoid running real installers, updaters, or publishing workflows as checks. If the user declines verification, skip those commands and report that limitation.

Follow the repository's commit policy. Use `git-commit` when committing and stage only the changes made for this task. Where coherent, separate license/REUSE adoption from infrastructure ownership; each commit must keep its references and packaging consistent. Do not force exactly two commits. Pushes, tags, releases, registry publication, remote settings, and history rewrites require their own authorization.

Finish with a concise report containing the selected outbound license and preserved upstream obligations, changed ownership surfaces, checks actually performed or skipped, and any remaining external setup. Claim only the behavior that was exercised. If licensing blocked the transition, report the blocking evidence and the decision needed to resume.

## Primary references

Consult these when the relevant rule needs confirmation. Read other original license texts when the target repository uses them.

- [REUSE Specification](https://reuse.software/spec-3.3/) — coverage, license texts, headers, annotations, and precedence.
- [REUSE download](https://reuse.readthedocs.io/en/stable/man/reuse-download.html) and [REUSE lint](https://reuse.readthedocs.io/en/stable/man/reuse-lint.html) — license installation and compliance checks.
- [MIT license text](https://spdx.org/licenses/MIT.html) — original notice preservation.
- [GNU AGPL version 3](https://www.gnu.org/licenses/agpl-3.0.html) — target license terms; use the exact requested SPDX variant.
