{
  pkgs ? import <nixpkgs-unstable> { },
}:
pkgs.mkShellNoCC {
  packages = with pkgs; [
    selene
    stylua
    sumneko-lua-language-server
  ];
}
