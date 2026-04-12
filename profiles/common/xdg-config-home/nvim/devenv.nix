{ pkgs, ... }:
{
  languages.lua.enable = true;

  git-hooks.hooks = {
    stylua.enable = true;
    typos.enable = true;
  };

  packages = with pkgs; [
    selene
    typos
  ];
}
