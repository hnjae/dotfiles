if (( ! $+commands[lf] )); then
  return
fi

function lfcd() {
  local tmp
  tmp="${TMPDIR:-/tmp}/lfcd-$RANDOM"

  # `command` is needed in case `lfcd` is aliased to `lf`
  command lf -last-dir-path="$tmp" "$@"

  if [[ -f $tmp ]]; then
    dir=$(<"$tmp")
    rm -f "$tmp"
    if [[ -d $dir && $dir != "$PWD" ]]; then
      cd -- "$dir" || return
    fi
  fi
}

alias lf=lfcd
