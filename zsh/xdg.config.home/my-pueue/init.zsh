# https://github.com/Nukesor/pueue

if (( ! $+commands[pueue] )); then
  return
fi

alias -- p=pueue
alias -- pK='pueue kill'
alias -- pa='pueue add'
alias -- pcl='pueue clean'
alias -- ped='pueue edit'
alias -- peq='pueue enqueue'
alias -- pfo='pueue follow'
alias -- pgr='pueue group'
alias -- ph='pueue help'
alias -- pl='pueue log'
alias -- pps='pueue pause'
alias -- prm='pueue remove'
alias -- prx='pueue restart'
alias -- psd='pueue send'
alias -- psh='pueue stash'
alias -- pst='pueue status'
alias -- psw='pueue switch'
alias -- pw='pueue wait'
alias -- px='pueue start'
