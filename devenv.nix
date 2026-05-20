{ pkgs, lib, ... }:
{
  git-hooks.install.enable = false;
  git-hooks.hooks = {
  };
  # git-hooks.hooks = {
  #   rumdl.enable = true;
  #   yamlfmt.enable = true;
  #   taplo.enable = true;
  #   typos.enable = true;
  #   biome = {
  #     enable = true;
  #     excludes = [ "lazy-lock\\.json" ];
  #   };
  #   "stylua-nvim" = {
  #     enable = true;
  #     name = "stylua nvim";
  #     entry = "${pkgs.stylua}/bin/stylua --respect-ignores --config-path profiles/common/xdg-config-home/nvim/.stylua.toml";
  #     files = "^profiles/common/xdg-config-home/nvim/.*\\.lua$";
  #     types = [
  #       "file"
  #       "lua"
  #     ];
  #     language = "system";
  #   };
  #   "stylua-yazi" = {
  #     enable = true;
  #     name = "stylua yazi";
  #     entry = "${pkgs.stylua}/bin/stylua --respect-ignores";
  #     files = "^profiles/common/xdg-config-home/yazi/.*\\.lua$";
  #     types = [
  #       "file"
  #       "lua"
  #     ];
  #     language = "system";
  #   };
  # };
}
