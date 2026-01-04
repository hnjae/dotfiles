local _hostname="$(hostname)"
if [[ ${_hostname} == "isis" || ${_hostname} == "osiris" ]]; then
    # temp
    # export DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1="1"
    # export VK_DRIVER_FILES="/run/current-system/sw/share/vulkan/icd.d/amd_icd64.json"

    # cd to commonly used directories
    alias sp='cd "$HOME/Projects"'
    alias sn='cd "$HOME/Projects/nix-config"'
    alias sf='cd "$HOME/Projects/dotfiles"'
    alias sv='cd "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"'
    alias sz='cd "${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}"'
    alias so='cd "$HOME/Projects/obsidian/home"'

    # edit commonly used files
    alias ed='vi "$HOME/Projects/obsidian/home/dailies/$(date +"%Y-%m-%d").md"'
    alias ew='vi "$HOME/Projects/obsidian/home/weeklies/$(date +"%G-W%V").md"'
fi

unset _hostname
