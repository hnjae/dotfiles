if (( ! ${+commands[eza]} )); then
  return
fi

# alias lx='ll -sextension'     # Long format, sort by extension
# alias lk='ll -ssize'          # Long format, largest file size last
# alias lt='ll -smodified'      # Long format, newest modification time last
# alias lc='ll -schanged'       # Long format, newest status change (ctime) last

# alias -- l='eza --group --links --time-style long-iso --color=always --icons=never --git --mounts --extended'
# alias -- ls='eza --group --links --time-style long-iso --color=automatic --icons=never --mounts --extended'
# alias -- la='l -a'
# alias -- etr='eza --tree --git-ignore'
# alias -- lla='l -la'
# alias -- lt='l --tree'

alias -- ls='eza'
alias -- l='eza --long --git'
alias -- ll='l --all'
alias -- lt='eza --tree'

function _chpwd_ls() {
  timeout 0.1s eza || echo "ls timeout"
}
chpwd_functions+=(_chpwd_ls)
