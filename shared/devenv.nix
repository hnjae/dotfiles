{ pkgs, ... }:
{
  packages = [
    pkgs.git
  ];

  git-hooks.hooks = {
    biome.enable = true;
    rumdl.enable = true;
  };
}
