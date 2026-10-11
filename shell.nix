{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShellNoCC {
  packages = import ./nix/dev-tools.nix pkgs;
  shellHook = ''
    just --justfile ${pkgs.lib.escapeShellArg (toString ./justfile)} hooks-install
  '';
}
