# https://github.com/muesli/duf

if (( ! $+commands[duf] )); then
  return
fi

function duf() {
  command duf --theme=ansi "$@"
}
