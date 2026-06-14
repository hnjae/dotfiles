# local-targets.yazi

Session-local target directories for netrw-style file transfers.

## Workflow

- Mark source entries with the `m` prefix.
- Set one or more target directories.
- Copy or move the marked entries to a selected target with netrw-style maps.
- Copy or move the marked entries to the current directory without adding a target.
- Stay in the current directory after target copy or move operations.
- Use the `c` prefix for explorer-style copy, move, and paste operations in the current directory.

## Keymap

- `c c` yanks selected entries for copy.
- `c x` yanks selected entries for move.
- `c v` pastes yanked entries into the current directory.
- `c V` force-pastes yanked entries into the current directory.
- `c u` clears the yank state.
- `m f` toggles the hovered file mark.
- `m F` unmarks entries in the current directory.
- `m u` clears all marks.
- `m t` adds the hovered directory as a target.
- `m .` adds the current directory as a target.
- `m c` copies marked entries to a selected target.
- `m m` moves marked entries to a selected target.
- `m C` copies marked entries to the current directory.
- `m M` moves marked entries to the current directory.
- `m x` clears yazi's target list.
- `m l` lists yazi's target list.
