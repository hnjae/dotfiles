typeset _hostname="$(hostname)"

if [[ ${_hostname} == "hemera" || ${_hostname} == "nyx" ]]; then
    # cd to commonly used directories
    alias sp='cd "$HOME/Projects"'
    alias sn='cd "$HOME/Projects/nix-config"'
    alias so='cd "$HOME/Projects/notes"'

    alias sf='cd "${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles"'
    alias sv='cd "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"'
    alias sz='cd "${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}"'
    alias sy='cd "${XDG_CONFIG_HOME:-$HOME/.config}/yazi"'

    # edit commonly used files
    # alias ed='vi "$HOME/Projects/obsidian/home/dailies/$(date +"%Y-%m-%d").md"'
    # alias ew='vi "$HOME/Projects/obsidian/home/weeklies/$(date +"%G-W%V").md"'

    alias virshc=' virsh -c "qemu+ssh://tofu@eris/system?socket=/run/libvirt/libvirt-sock"'
fi

unset _hostname
