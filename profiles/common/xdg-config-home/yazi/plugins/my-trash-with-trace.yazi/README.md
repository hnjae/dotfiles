# my-trash-with-trace.yazi

Local functional plugin for this dotfiles setup.

- `<F3>` runs on the selected files, or the hovered file when nothing is selected
- writes `<stem> DELETED` in the same directory
- stores `mediainfo -- <file>` output in that trace file
- trashes the original file via `trash-put`
