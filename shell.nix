# SPDX-License-Identifier: AGPL-3.0-or-later
# SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

let
  nixpkgs = fetchTarball "github:cachix/devenv-nixpkgs/rolling";
  pkgs = import nixpkgs {
    config = { };
    overlays = [ ];
  };
in
pkgs.mkShellNoCC {
  packages = import ./nix/dev-tools.nix pkgs;
  shellHook = # sh
    ''
      just --justfile ${pkgs.lib.escapeShellArg (toString ./justfile)} hooks-install
    '';
}
