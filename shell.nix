{
  pkgs ? import <nixpkgs-unstable> { },
}:
pkgs.mkShell {
  packages = with pkgs; [
    selene
    stylua
    sumneko-lua-language-server
  ];
}
