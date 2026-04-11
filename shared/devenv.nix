{ pkgs, ... }:
{
  packages = with pkgs; [
    git
    just
    editorconfig-checker
  ];

  git-hooks.hooks = {
    rumdl.enable = true;
    yamlfmt.enable = true;
  };
}
