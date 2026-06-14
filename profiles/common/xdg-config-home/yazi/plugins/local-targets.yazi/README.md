# local-targets.yazi

Session-local target directories for netrw-style file transfers.

## Workflow

- Mark source entries with the `m` prefix.
- Set one or more target directories.
- Yank the marked entries for copy or move.
- Send the yanked entries to a selected target.

## Keymap

- `m f` toggles the hovered file mark.
- `m a` marks all entries in the current directory.
- `m r` reverses marks in the current directory.
- `m F` unmarks entries in the current directory.
- `m u` clears all marks.
- `m t` adds the hovered directory as a target.
- `m .` adds the current directory as a target.
- `m l` lists targets.
- `m c` clears targets.
- `m y` yanks marked entries for copy.
- `m x` yanks marked entries for move.
- `m p` pastes yanked files to a selected target.
- `m P` force-pastes yanked files to a selected target.
- `m U` clears the yank state.
