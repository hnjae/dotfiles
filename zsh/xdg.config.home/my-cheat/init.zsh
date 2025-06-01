if (( ! $+commands[cheat] )); then
  return
fi

# https://github.com/cheat/cheat

alias ch="cheat"
alias che="cheat -e"

if (( $+commands[fzf] )); then
  export CHEAT_USE_FZF="true"
fi
