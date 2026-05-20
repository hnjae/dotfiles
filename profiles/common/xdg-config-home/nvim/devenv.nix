# packages/api/devenv.nix
{
  pkgs,
  ...
}:
{
  packages = [
    pkgs.selene
    pkgs.fd
  ];

  # package-local hooks
  git-hooks.hooks = {
    typos.enable = true;
  };

  tasks = {
    "nvim:lint" = {
      exec = "fd --type f --extension lua . -X selene --allow-warnings";
      before = [ "ci:check" ];
    };
  };
}
