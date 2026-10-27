# Agent Guidelines

- **No backward compatibility**: This repo has one user. Make clean breaks; skip migrations, shims, and legacy support unless explicitly requested.
- **Commits**: Use Conventional Commits. Pick the narrowest accurate scope:
    - subproject name, for changes localized to one tool under `apps/`;
    - otherwise a repo-level scope (`ci`, `docs`, `deps`, `nix`);
    - omit the scope only when none fits.
- **Profile directory names**: Under `profiles/<profile>/`, a link source is named `<anchor>[+<subpath>][@<mode>]`.
    - Its children are symlinked into the target by a `glob: true` entry in that profile's `install.conf.yaml`, so adding a child needs no yaml edit.
    - `anchor` is `home`, `xdg-config-home`, `xdg-data-home`, or `xdg-bin-home`. `subpath` is the path below the anchor with `/` written as `+`, keeping dots literal (`home+.omp+agent` → `~/.omp/agent`).
    - `@seed` copies instead of linking. A directory starting with `_` is not a link source (`_install` holds scripts run by `install.conf.yaml`).
    - Use a dedicated directory only where the target must stay a real directory (it holds runtime files). Otherwise link the whole directory as a child of its anchor.
