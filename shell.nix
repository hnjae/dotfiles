# SPDX-License-Identifier: AGPL-3.0-or-later
# SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

let
  nixpkgs = fetchTarball "https://github.com/cachix/devenv-nixpkgs/archive/refs/heads/rolling.tar.gz";
  pkgs = import nixpkgs {
    config = { };
    overlays = [ ];
  };
in
pkgs.mkShellNoCC {
  packages = import ./nix/dev-tools.nix pkgs;
  shellHook = # sh
    ''
      prek install --quiet
    '';
}
