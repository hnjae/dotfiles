{ pkgs, ... }:
{
  languages.lua.enable = true;

  git-hooks.hooks = {
    stylua.enable = true;
    taplo.enable = true;
    ruff-format.enable = true;
  };

  packages = with pkgs; [
    just

    selene
    typos
    ty
  ];
}
