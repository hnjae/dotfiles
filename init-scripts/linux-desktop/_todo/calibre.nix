{
  config,
  lib,
  pkgs,
  ...
}:
let
  baseHomeCfg = config.base-home;
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{
  config = lib.mkIf (baseHomeCfg.isDesktop && isLinux) ({
    xdg.mimeApps.associations.removed =
      let
        desktopName = "com.calibre_ebook.calibre.desktop";
        mimeTypes = [
          "application/epub+zip"
          "application/ereader"
          "application/oebps-package+xml"
          "application/pdf"
          "application/vnd.ms-word.document.macroenabled.12"
          "application/vnd.oasis.opendocument.text"
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
          "application/x-cb7"
          "application/x-cbc"
          "application/x-cbr"
          "application/x-cbz"
          "application/x-mobi8-ebook"
          "application/x-mobipocket-ebook"
          "application/x-mobipocket-subscription"
          "application/x-sony-bbeb"
          "application/xhtml+xml"
          "image/vnd.djvu"
          "text/fb2+xml"
          "text/html"
          "text/plain"
          "text/rtf"
          "text/x-markdown"
        ];
      in
      (builtins.listToAttrs (
        builtins.map (mimeType: {
          name = mimeType;
          value = desktopName;
        }) mimeTypes
      ));
  });
}
