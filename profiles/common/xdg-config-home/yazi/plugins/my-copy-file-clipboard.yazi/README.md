# my-copy-file-clipboard.yazi

- `yy` copies the selected entries, or the hovered entry when nothing is selected
- it writes a `text/uri-list` payload to the desktop clipboard via `wl-copy`
- this is aimed at file-manager paste on Wayland, especially Dolphin and other Qt file managers
- modern Nautilus may still want its own clipboard MIME, so this mapping prioritizes the Plasma/Qt side
