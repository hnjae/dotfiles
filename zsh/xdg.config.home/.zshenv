setopt no_global_rcs # do not source global zshrc/zprofile files

typeset _hm_vars="$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
[[ -f "$_hm_vars" ]] && source "$_hm_vars"

export EDITOR="nvim"
export VISUAL="nvim"
