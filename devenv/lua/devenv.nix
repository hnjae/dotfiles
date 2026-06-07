{
  pkgs,
  ...
}:
{
  # https://devenv.sh/languages/lua/
  languages.lua.enable = true;

  packages = [
    pkgs.selene
    pkgs.fd
  ];

  tasks = {
    "ci:lint" = {
      exec = "fd --type f --extension lua . -X selene --allow-warnings";
    };
  };
}
