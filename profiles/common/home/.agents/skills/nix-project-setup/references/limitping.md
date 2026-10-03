# Reference: limitping development setup

The user identified upstream commit `6052828a5e595e0918206b927d875384e7c85dd1` as the fork point. The inspected reference state is `dad52b39f33af0f8dda1b664260c69e790cb55eb` in `hnjae/limitping`. This record captures development setup intent; it does not require either checkout to be available when the skill runs.

The relevant history introduces the Nix workflow in `4bee2bc`, direnv in `8b0afda`, additional hooks in `010db7b`, just recipes in `92da343`, and centralized CI checks in `242a5ea`. Other changes in the same fork history concern licensing, ownership, feature removal, localization, release automation, and documentation cleanup. Those are separate tasks, not consequences of adopting this setup.

| Surface         | Reference convention                                                             | Adaptation rule                                                              |
| --------------- | -------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| Root inputs     | FlakeHub nixpkgs-weekly `/0`, flake-parts following nixpkgs                      | Retain target-required builder inputs and justified existing pins            |
| Package         | Root `perSystem.packages.default`, Go CLI, CGO disabled                          | Choose the target's builder, executable, dependencies, and CGO/native policy |
| Development     | `partitions.dev.module`, separate dev input flake and lock                       | Keep hooks, formatting, shells, and project checks out of package evaluation |
| Output routing  | `checks`, `devShells`, `formatter` assigned to `dev`                             | Preserve this separation and existing public outputs                         |
| Formatting      | treefmt-nix: gofmt, nixfmt, rumdl-format, taplo, yamlfmt, just                   | Match actual languages and file types                                        |
| Hooks           | prek; treefmt, Cocogitto commit-msg, private-key detection, typos, REUSE         | REUSE depends on existing licensing policy; do not relicense                 |
| Go checks       | vet, race tests, coverage summary in a dedicated check build                     | Preserve effective CI checks, adapt to the language/platform                 |
| Shell           | formatter tools via `inputsFrom`, Go, enabled hook packages, combined shell hook | Supply target tools; preserve regular config files and local hooks           |
| Companion files | EditorConfig, direnv watching two locks, just wrappers                           | Merge useful existing behavior and language-specific indentation             |
| CI              | `nix flake check` invokes the authoritative checks                               | Change only applicable build/check jobs within requested scope               |

The reference supports `x86_64-linux`, `aarch64-linux`, and `aarch64-darwin`. Its executable is `limitping`; its Go subpackage is `cmd/limitping`; its dependency hash and typo exceptions are project-specific. None are defaults for unrelated projects. Its SPDX headers reflect a separate AGPL/REUSE transition; use the target's established license policy for new setup files.

Older templates in `hnjae/nix-templates` may use different input names, module layouts, or a hook-runner formatter. Prefer the limitping structure for this request, while respecting any newer template explicitly supplied by the user.
