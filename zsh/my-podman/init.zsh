if (( ! $+commands[podman] )) ; then
  return
fi

alias pm='podman'
alias pmh='podman --help | bat'
alias pmc='podman container'
alias pmcl='podman container ls'
alias pmi='podman image'
alias pmil='podman image ls'
alias pmn='podman network'
alias pmnl='podman network ls'
alias pmv='podman volume'
alias pmvl='podman volume ls'
alias pmK='podman kill'
alias pmst='podman stats'
alias pmx='podman run'
