{
  pkgs,
  lib,
  ...
}:
{
  packages = with pkgs; [
    # Configured in treefmt:
    biome
    just
    nixfmt
    rumdl
    shellcheck
    shellharden
    shfmt
    taplo
    yamlfmt
  ];

  # https://devenv.sh/reference/options/#treefmtenable
  treefmt.enable = true;
  treefmt.config =
    let
      shellFilePatterns = [
        "*.sh"
        "*.bash"
        ".envrc"
        ".envrc.*"
        ".env"
        ".env.*"
      ];
    in
    {
      projectRootFile = "LICENSE";
      settings = {
        excludes = [
          "*.lock"
          "*/zed/*.json"
        ];

        formatter.shellharden = {
          command = lib.getExe pkgs.shellharden;
          options = [ "--replace" ];
          includes = shellFilePatterns;
          priority = 10;
        };
      };

      programs = {
        nixfmt.enable = true;
        taplo.enable = true;
        yamlfmt.enable = true;
        just.enable = true;
        rumdl-check.enable = true;
        rumdl-format.enable = true;

        # Shell
        shellcheck = {
          enable = true;
          includes = shellFilePatterns;
          priority = 20;
        };
        shfmt = {
          enable = true;
          includes = shellFilePatterns;
          priority = 30;
          useEditorConfig = true;
        };

        # json, js
        biome = {
          enable = true;
          settings = {
            formatter = {
              useEditorconfig = true;
            };
          };
        };
        ruff-format.enable = true;
        stylua.enable = true;
      };
    };
}
