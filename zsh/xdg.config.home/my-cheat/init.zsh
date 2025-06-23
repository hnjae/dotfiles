# https://github.com/cheat/cheat

# TODO: source "https://github.com/cheat/cheat/blob/master/scripts/cheat.zsh" <2025-06-08>
# /nix/store/k1am50l3yxninsc05dgg13bs45l5x75a-cheat-4.4.2/share/zsh/site-functions/_cheat 에 위치.

if (( ! $+commands[cheat] )); then
  return
fi

__CHEATPATH="${XDG_CONFIG_HOME:-${HOME}/.config}/cheat/cheatsheets/personal/"

alias ch="cheat"
alias che="cheat -e"
alias chl="cheat -l"

if (( $+commands[fzf] )); then
  export CHEAT_USE_FZF="true"

  function __cheat_select() {
    local term="$1"
    local file

    file="$(
      (
        fd "$term" "$__CHEATPATH" --type file
      ) |
        sed -e "s|^$__CHEATPATH||g" |
        fzf --select-1 --exit-0 --preview='bat -l sh --color=always --italic-text=always --paging=never --decorations=never '"$__CHEATPATH"'/{}'
    )"

    echo "$__CHEATPATH/$file"
  }

  function cheat-edit() {
    local file
    if [[ "$1" != "" ]]; then
      file="$__CHEATPATH/$1"
    else
      file="$(__cheat_select ".")"
      [[ "$file" == "" ]] && return
    fi

    nvim -- "$file"
  }

  alias che="cheat-edit"
fi
