{ pkgs, ... }:
{
  languages.lua.enable = false;

  git-hooks.hooks = {
    stylua.enable = true;
    typos.enable = true;
  };

  packages = with pkgs; [
    selene
    typos
  ];
}
