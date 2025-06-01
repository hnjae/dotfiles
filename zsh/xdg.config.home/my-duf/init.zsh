# https://github.com/muesli/duf

if (( ! $+commands[duf] )); then
  return
fi

alias duf="duf -theme ansi"
alias duf="duf --hide special"
