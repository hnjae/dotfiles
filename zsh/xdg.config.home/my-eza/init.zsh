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

# TODO: eza 는 설정파일로 관리가능한가? 너무 길어지는데. <2025-06-17>
alias -- ls='eza'
alias -- l='eza --long --header --all --group --time-style="+%Y-%m-%d %H:%M:%S" --octal-permissions --no-permissions'
alias -- ll='l --all'
# alias -- lt='eza --tree --all --git-ignore'
alias -- lt=' eza -l --git -T --hyperlink --header'

function _chpwd_ls() {
  timeout 0.1s eza || echo "ls timeout"
}
chpwd_functions+=(_chpwd_ls)
