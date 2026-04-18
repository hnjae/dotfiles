{ pkgs, ... }:
{
  packages = with pkgs; [
    editorconfig-checker
  ];

  git-hooks.hooks = {
    typos.enable = true;
  };
}
