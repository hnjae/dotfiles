{
  pkgs,
  lib,
  config,
  ...
}:
{
  # https://devenv.sh/git-hooks/
  git-hooks.excludes = [ ".*\\.lock$" ];
  git-hooks.hooks = {
    # Static checkers
    detect-private-keys.enable = true;
    cocogitto = {
      enable = true;
      name = "cog verify";
      description = "Lint commit messages with Cocogitto.";
      package = pkgs.cocogitto;
      entry = "${lib.getExe pkgs.cocogitto} verify --file";
      stages = [ "commit-msg" ];
    };
    typos.enable = true;

    # Formatter check
    treefmt.enable = true;

    # Miscellaneous Checkers/Linters:
    deadnix.enable = true;
    statix.enable = true;
    rumdl.enable = true;
  };
  tasks."ci:git-hooks" = {
    exec = "${lib.getExe config.git-hooks.package} run --all-files";
  };
}
