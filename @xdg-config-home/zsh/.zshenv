# README:
#   이 파일은 $ZDOTDIR/.zshenv, $HOME/.zshenv 두 곳에 존재해야한다.
#   관찰 결과, 위 두 파일을 모두 읽는 경우는 없는 듯.

setopt no_global_rcs # do not source global zshrc/zprofile files

typeset _hm_vars="$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
[[ -f "$_hm_vars" ]] && source "$_hm_vars"

export EDITOR="nvim"
export VISUAL="nvim"

export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# autoload -Uz +X compinit
# functions[compinit]=$'print -u2 \'compinit being called at \'${funcfiletrace[1]}
# '${functions[compinit]}
