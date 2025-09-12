# NOTE: opera is only browser that support netflix 1080p on linux <2024-11-24>
# https://help.netflix.com/en/node/30081
{
  lib,
  config,
  pkgs,
  ...
}:
let
  appId = "com.opera.Opera";

  baseHomeCfg = config.base-home;
  inherit (pkgs.stdenv.hostPlatform) isLinux isx86_64;

  cond =
    baseHomeCfg.isDesktop && baseHomeCfg.isHome && isLinux && isx86_64 && pkgs.config.allowUnfree;
in
{
  config = lib.mkIf (cond) {
    xdg.mimeApps.associations.removed =
      let
        desktopName = "${appId}.desktop";
        mimeTypes = [
          "application/pdf"
          "application/rdf+xml"
          "application/rss+xml"
          "application/xhtml+xml"
          "application/xhtml_xml"
          "application/xml"
          "image/gif"
          "image/jpeg"
          "image/png"
          "image/webp"
          "text/html"
          "text/xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/ipfs"
          "x-scheme-handler/ipns"
        ];
      in
      (builtins.listToAttrs (
        builtins.map (mimeType: {
          name = mimeType;
          value = desktopName;
        }) mimeTypes
      ));
  };

}
