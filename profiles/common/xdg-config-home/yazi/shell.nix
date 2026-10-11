{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShellNoCC {
  packages = (import ../../../../nix/dev-tools.nix pkgs) ++ [
    pkgs.lua5_2
    pkgs.lua-language-server
    pkgs.selene
    pkgs.fd
    pkgs.ty
  ];
}
