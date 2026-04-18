{ pkgs, ... }:
{
  packages = with pkgs; [
    editorconfig-checker
  ];

  git-hooks.hooks = {
    rumdl.enable = true;
    yamlfmt.enable = true;
    biome.enable = true;
  };
}
