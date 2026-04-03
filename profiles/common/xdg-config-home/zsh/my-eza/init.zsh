if (( ! ${+commands[eza]} )); then
    return
fi

# NOTE:
# --long: display in table
# --header: show header in table
# --group: show file's group (if using `--long` option)
# --all: show hidden and dotfiles
# --binary: 파일 사이즈를 SI 접두어가 아니라 이진 접두어로 표기 (`--long` 옵션을 사용해야 함)
# --git: list git status (if using `--long` option)
# --mounts: show mount details

# `ls` alias 에 내가 기본값으로 사용하는 옵션을 추가
# - use octal permissions to save horizontal space

alias -- ls='eza --group-directories-first --header --octal-permissions --no-permissions --time-style="+%Y-%m-%d %H:%M:%S" --group --binary --git --mounts --numeric'
alias -- l='ls --long'
alias -- ll='l --all'
alias -- lt='l --tree --level=3 --git-ignore --color=always | $PAGER'

# function _chpwd_ls() {
#   timeout 0.1s ls || echo "ls timeout"
# }
#
# chpwd_functions+=(_chpwd_ls)
