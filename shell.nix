let
  nixpkgs = fetchTarball "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0.1";
  pkgs = import nixpkgs {
    config = { };
    overlays = [ ];
  };
in
pkgs.mkShellNoCC {
  packages = import ./nix/dev-tools.nix pkgs;
  shellHook = ''
    just --justfile ${pkgs.lib.escapeShellArg (toString ./justfile)} hooks-install
  '';
}
