{ pkgs, ... }:
{
  languages.lua.enable = true;

  packages = with pkgs; [
    selene
  ];
}
