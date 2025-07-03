if (( ! $+commands[yazi] )); then
  return
fi

function y() {
  local tmp
  # local tmpdir
  # tmpdir="${TMPDIR:-/tmp}/yazi-${UID:-"$(id -u)"}"
  # [[ ! -d "${tmpdir}" ]] && mkdir -p "${tmpdir}"
  # tmp="$(mktemp -p "$tmpdir" --suffix=".yazi.cwd")"

  tmp="${TMPDIR:-/tmp}/yazicd-$RANDOM"
    # `command` is needed in case something is aliased to `yazi`
    command yazi --cwd-file="$tmp" "$@"
    if [[ -f "$tmp" ]]; then
      if cwd="$(cat "$tmp")" && [[ -n "$cwd" ]] &&
        [[ -d "$cwd" && "$cwd" != "${PWD:-$(pwd)}" ]]; then
        cd -- "$cwd" || return
      fi

      rm -f -- "$tmp"
    fi
}
