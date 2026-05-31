{ pkgs, ... }:
{
  languages.lua.enable = true;

  packages = [
    pkgs.selene
    pkgs.fd
  ];

  # package-local hooks
  git-hooks.hooks = {
    typos.enable = true;
  };
}
