{
  pkgs,
  pkgsUnstable,
  lib,
  ...
}:
let
  package = pkgsUnstable.pueue;
  help = pkgs.runCommandLocal "pueued-help" { } ''
    ${package}/bin/pueued --help >$out
  '';
in
{
  # https://github.com/Nukesor/pueue
  home.packages = [ package ];

  systemd.user.services.pueued = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux) {
    Unit = {
      Description = "pueue daemon";
      Documentation = [
        "https://github.com/Nukesor/pueue"
        "file:${help}"
      ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${package}/bin/pueued";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
