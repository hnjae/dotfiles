{ pkgs, ... }:
{
  packages = with pkgs; [
    editorconfig-checker
  ];
}
