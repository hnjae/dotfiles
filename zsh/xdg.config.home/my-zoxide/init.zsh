if (( ! $+commands[zoxide] )); then
  return
fi

$commands[zoxide] init zsh --no-cmd >| ${0:A:h}/zoxide.zsh

export _ZO_EXCLUDE_DIRS="$HOME:/nix/*:/mnt/*:/proc/*:*/.git:*/.cache:*/.direnv"
# `_ZO_FZF_OPTS` 없으면 fzf 의 extended-search 가 작동하지 않는다. fzf 를 안사용하게 되나? <2025-04-11>
export _ZO_FZF_OPTS="${FZF_DEFAULT_OPTS} --scheme=path"
source ${0:A:h}/zoxide.zsh

function cd() {
  if [[ "$#" -gt 0 && "$1" == "--" ]]; then
    shift
  fi

  if [[ "$#" -eq 0 ]]; then
    return 0
  fi

  if [[ "$#" -gt 1 ]]; then
    print -u2 "cd: too many arguments"
    return 1
  fi


  if [[ -f "$1" ]]; then
    __zoxide_z "$(dirname "$1")"
  elif [[ -d "$1" ]]; then
    __zoxide_z "$1"
  else
    print -u2 "cd: $1: No such file or directory"
    return 1
  fi
}

function s() {
  if [[ "$#" -gt 0 && "$1" == "--" ]]; then
    shift
  fi

  if [[ -f "$*" ]]; then
    __zoxide_z "$(dirname "$*")"
  else
    __zoxide_z "$@"
  fi
}

function si() {
  __zoxide_zi "$@"
}
