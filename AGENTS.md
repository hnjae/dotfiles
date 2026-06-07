# Agent Guidelines

- **No backward compatibility**: This repo has one user. Make clean breaks; skip migrations, shims, and legacy support unless explicitly requested.
- **Commits**: Use Conventional Commits. Pick the narrowest accurate scope:
    - subproject name, for changes localized to one tool under `apps/`;
    - otherwise a repo-level scope (`ci`, `docs`, `deps`, `nix`);
    - omit the scope only when none fits.
