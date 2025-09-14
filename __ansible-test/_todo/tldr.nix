{
  pkgs,
  pkgsUnstable,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  package = pkgsUnstable.tealdeer;

  serviceName = "tldr-update";
  Description = "daily update tldr";
  help = pkgs.runCommandLocal "tldr-help" { } ''
    ${package}/bin/tldr --help >$out
  '';
  Documentation = [ "file:${help}" ]; # no man page for tealdeer <NixOS 23.11; tealdeer 1.6.1>

  tldrUpdateScript = pkgs.writeScript "tldr-update" ''
    #!${pkgs.dash}/bin/dash

    set -eu

    PATH=${
      lib.makeBinPath [
        package
        pkgs.inetutils
        pkgs.coreutils
      ]
    }

    MAX_RETRY=5
    PAUSE_SEC=120
    i=0
    while [ "$i" -lt "$MAX_RETRY" ]; do
      if ping -c 1 1.1.1.1 >/dev/null 2>&1; then
        break
      fi

      if [ "$i" -ge "$MAX_RETRY" ]; then
        echo "INFO: Internet is not connected."
        exit 0
      fi

      echo "INFO: Waiting Internet connection. Will retry after ''${PAUSE_SEC}s."
      sleep "$PAUSE_SEC"
    done
    unset i

    tldr --update
  '';
in
{
  home.packages = [ package ];

  systemd.user.services."${serviceName}" = lib.mkIf isLinux {
    Unit = {
      inherit Description Documentation;

      # NOTE: systemd-user 에서는 network-online 을 알수 없음
      After = [
        # "dbus.socket"
        # "pipewire.socket"
        # "xdg-desktop-portal.service"
        "multi-user.target"
      ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${tldrUpdateScript}";
      CPUSchedulingPolicy = "idle";
      IOSchedulingClass = "idle";
      # Nice = 19;
    };
  };

  systemd.user.timers."${serviceName}" = lib.mkIf isLinux {
    Unit = { inherit Description Documentation; };

    Timer = {
      OnCalendar = "*-*-* 04:00:00";
      AccuracySec = "1h";
      Persistent = true;

      # AccuracySec = "1m";
      # OnStartupSec = "20m";
      # OnUnitInactiveSec = "12h";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
