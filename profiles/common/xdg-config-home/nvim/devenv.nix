{ pkgs, ... }:
{
  languages.lua.enable = false;

  packages = with pkgs; [
    selene
  ];
}
