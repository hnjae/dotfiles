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
