if (( ! $+commands[tmux] )); then
  return
fi

alias -- t=tmux
alias -- ta='tmux attach'
alias -- tat='tmux attach -t'
alias -- tc='tmux -c'
alias -- tls='tmux ls'
alias -- tn='tmux new-session -n'
alias -- trn='tmux rename-session'
