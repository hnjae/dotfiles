# Flake pattern

Use this complete example to understand the boundary. It builds a Go application with only standard-library dependencies, a `go.mod`, and its executable in `cmd/example-cli`. Change the identity, entry point, dependency hash, platform list, package builder, tools, and checks for the target. `vendorHash = null` is specific to this example's absence of external dependencies. The two package definitions deliberately keep the small setup inline, as in the reference; keep their package identity and dependency settings consistent when adapting.

Copy or adapt `assets/nix/partitions/dev/flake.nix` for the development input subflake. Generate both lockfiles with Nix. License headers are omitted from these templates so they do not impose the reference fork's license on the target.

```nix
{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      imports = [ inputs.flake-parts.flakeModules.partitions ];

      partitions.dev.extraInputsFlake = ./nix/partitions/dev;
      partitions.dev.module = { inputs, ... }: {
        imports = [
          inputs.git-hooks.flakeModule
          inputs.treefmt-nix.flakeModule
        ];

        perSystem =
          {
            config,
            pkgs,
            lib,
            ...
          }:
          {
            treefmt.projectRootFile = "flake.nix";
            treefmt.programs = {
              gofmt.enable = true;
              nixfmt.enable = true;
              rumdl-format.enable = true;
              taplo.enable = true;
              yamlfmt.enable = true;
              just.enable = true;
            };

            pre-commit.settings.package = pkgs.prek;
            pre-commit.settings.hooks = {
              cocogitto = {
                enable = true;
                name = "cog verify";
                description = "Lint commit messages with Cocogitto.";
                package = pkgs.cocogitto;
                entry = "${lib.getExe pkgs.cocogitto} verify --file";
                stages = [ "commit-msg" ];
              };
              detect-private-keys.enable = true;
              treefmt.enable = true;
              typos.enable = true;
            };

            checks.example-cli = pkgs.buildGoModule {
              pname = "example-cli";
              version = "unstable";
              src = ./.;
              vendorHash = null;
              subPackages = [ "cmd/example-cli" ];
              env.CGO_ENABLED = "0";
              nativeBuildInputs = [ pkgs.stdenv.cc ];
              doCheck = true;
              checkPhase = ''
                runHook preCheck
                go vet ./...
                CGO_ENABLED=1 go test -race -coverprofile=coverage.out -covermode=atomic ./...
                go tool cover -func=coverage.out
                runHook postCheck
              '';
            };

            devShells.default = pkgs.mkShellNoCC {
              inputsFrom = [ config.treefmt.build.devShell ];
              packages = [ pkgs.go ] ++ config.pre-commit.settings.enabledPackages;
              shellHook = lib.concatLines [
                config.pre-commit.shellHook
                ''
                  if [ ! -e treefmt.toml ] || [ -L treefmt.toml ]; then
                    ln -sfn ${config.treefmt.build.configFile} treefmt.toml
                  fi
                ''
              ];
            };
          };
      };

      partitionedAttrs = {
        checks = "dev";
        devShells = "dev";
        formatter = "dev";
      };

      perSystem = { pkgs, ... }: {
        packages.default = pkgs.buildGoModule {
          pname = "example-cli";
          version = "unstable";
          src = ./.;
          vendorHash = null;
          subPackages = [ "cmd/example-cli" ];
          env.CGO_ENABLED = "0";
        };
      };
    };
}
```

Use the standard `shellHook` from git-hooks.nix; it manages the generated hook configuration and hook installation. Do not substitute manual `.git/hooks` copies. Keep `treefmt.enable = true` in the hook settings so the hook and `nix fmt` use the same configuration. Add `reuse.enable = true` only when REUSE applies to the target.

Common tool settings in the reference include `taplo.toml` with `[formatting] array_auto_collapse = false` and `yamlfmt.yaml` with `include_document_start: true`, `indent: 2`, and `scan_folded_as_literal: true` under `formatter`. Carry these only when the tools and conventions apply. The reference's `statix.toml` exists without an enabled statix hook; it is not required by this pattern.

## Primary documentation

Consult the versions pinned by the target when options differ. These sources explain the underlying modules; the user's reference defines the desired convention.

- [flake-parts partitions](https://flake.parts/options/flake-parts-partitions.html): independent output evaluation, extra input flake, and locally resolved `follows` paths.
- [treefmt-nix](https://flake.parts/options/treefmt-nix.html): generated config, formatter wrapper, development shell, and formatting check.
- [git-hooks.nix](https://flake.parts/options/git-hooks-nix.html): hooks, hook check, enabled packages, and shell initialization.
