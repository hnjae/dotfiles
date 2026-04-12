# my-copy-file-content.yazi

- `yc` copies the selected file, or the hovered file when nothing is selected
- it errors when more than one file is selected
- text files are copied as `text/plain`
- image files are copied with their original `image/*` MIME type
- files larger than 4 MiB are rejected
