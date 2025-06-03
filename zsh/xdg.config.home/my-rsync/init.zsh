if (( ! $+commands[rsync] )); then
  return
fi

alias -- rcp='rsync --info=progress2 -h -s -aHAXWE --numeric-ids --exclude-from=/nix/store/91kxd4ck00jgsw2ia6k2ly6lklz38bnh-rsync-exclude'
alias -- rcp-mtp='rsync --info=progress2 -h -rt -W -s --safe-links --checksum --cc=xxh3 --omit-dir-times --no-perms --inplace --exclude-from=/nix/store/91kxd4ck00jgsw2ia6k2ly6lklz38bnh-rsync-exclude'
alias -- rcp-paranoid='rsync --info=progress2 -h -s -aHAXWE --numeric-ids --exclude-from=/nix/store/91kxd4ck00jgsw2ia6k2ly6lklz38bnh-rsync-exclude --checksum --cc=xxh3'
alias -- rcp-remote='rsync --info=progress2 -h -s -aHAXWE --numeric-ids --exclude-from=/nix/store/91kxd4ck00jgsw2ia6k2ly6lklz38bnh-rsync-exclude -z --zc=zstd --zl=3 -e "ssh -T -c aes128-gcm@openssh.com -o Compression=no -x"'
alias -- rcp-sync='rsync --info=progress2 -h -s -aHAXWE --numeric-ids --fuzzy --delete-after'
alias -- rmv='rsync --info=progress2 -h -s -aHAXWE --numeric-ids --exclude-from=/nix/store/91kxd4ck00jgsw2ia6k2ly6lklz38bnh-rsync-exclude --remove-source-files'
alias -- rmv-remote='rsync --info=progress2 -h -s -aHAXWE --numeric-ids --exclude-from=/nix/store/91kxd4ck00jgsw2ia6k2ly6lklz38bnh-rsync-exclude --remove-source-files -z --zc=zstd --zl=3 -e "ssh -T -c aes128-gcm@openssh.com -o Compression=no -x"'
