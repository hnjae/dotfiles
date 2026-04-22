typeset _hostname="$(hostname)"

if [[ ${_hostname} == "hemera" || ${_hostname} == "nyx" ]]; then
    # cd to commonly used directories
    alias sp='cd "$HOME/projects"'
    alias sn='cd "$HOME/projects/nix-config"'
    alias sf='cd "$HOME/projects/dotfiles"'
    alias sv='cd "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"'
    alias sz='cd "${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}"'
    alias so='cd "$HOME/projects/notes"'
    alias sy='cd "${XDG_CONFIG_HOME:-$HOME/.config}/yazi"'
    alias sn='cd "$HOME/projects/nix-config"'

    # edit commonly used files
    # alias ed='vi "$HOME/Projects/obsidian/home/dailies/$(date +"%Y-%m-%d").md"'
    # alias ew='vi "$HOME/Projects/obsidian/home/weeklies/$(date +"%G-W%V").md"'

    alias virshc=' virsh -c "qemu+ssh://tofu@eris/system?socket=/run/libvirt/libvirt-sock"'
fi

unset _hostname
