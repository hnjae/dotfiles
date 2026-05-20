{
  config,
  pkgs,
  lib,
  ...
}:
{
  git-hooks = {
    # 하위 devenv는 repo-level .git/hooks를 설치/변경하지 않는다.
    install.enable = false;
    package = pkgs.prek;
    hooks = {
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
  };

  # https://devenv.sh/packages/
  # packages = with pkgs; [ ];

  # https://devenv.sh/languages/
  languages.nix.enable = true;

  treefmt = {
    enable = true;
    config = {
      settings = {
        excludes = [
          "*.lock"
          "*-lock.*"
        ];
      };
      programs = {
        nixfmt.enable = true;
        taplo.enable = true;
        yamlfmt.enable = true;
        just.enable = true;
        rumdl-format.enable = true;
        # biome.enable = true;
        shellcheck.enable = true;
        shfmt = {
          enable = true;
          useEditorConfig = true;
        };
      };
    };
  };

  tasks = {
    "ci:check" = { };
    "ci:git-hooks" = {
      exec = "${lib.getExe config.git-hooks.package} run --all-files";
      after = [ "devenv:files" ];
      before = [ "ci:check" ];
    };
  };

  enterShell =
    # sh
    ''
      set -eu

      config_path=".pre-commit-config.yaml"
      generated_config="${config.git-hooks.configFile}"

      if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        cwd="$(pwd -P)"
        git_root="$(git rev-parse --show-toplevel)"
        git_root="$(cd "$git_root" && pwd -P)"

        if [ "$cwd" != "$git_root" ]; then
          if [ -e "$config_path" ] && [ ! -L "$config_path" ]; then
            echo "ERR: $PWD/$config_path already exists and is not a symlink." >&2
            echo "Refusing to overwrite it." >&2
          else
            ln -sfn "$generated_config" "$config_path"
            echo "INfO: Updated $PWD/$config_path -> $generated_config"
          fi
        fi
      fi
    '';

  scripts.prek = {
    description = "Disabled in subproject shells; use root installer";
    exec = # sh
      ''
        set -eu

        cat >&2 <<'EOF'
        ERROR: `prek` is disabled in subproject devenv shells.

        Git hooks are owned by the repository root.
        Run from the repository root instead:

          devenv run install-hooks

        For package-local checks, use:

          devenv run check-hooks

        EOF
        exit 1
      '';
  };
}
