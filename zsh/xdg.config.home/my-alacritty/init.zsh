if [[ "$TERM" == "dumb" || "$ALACRITTY_WINDOW_ID" == "" || "$TERM_PROGRAM" == "" ]]; then
  return
fi

if (( ! $+commands[alacritty] )); then
  return
fi

function _set_terminal_title() {
  echo -e "\033]0;$*\007"
}

_alacritty_precmd() {
  _set_terminal_title "''${PWD##*/}"
}
precmd_functions+=(_alacritty_precmd)

_alacritty_preexec() {
  _set_terminal_title "''${1} (''${PWD##*/})"
}
preexec_functions+=(_alacritty_preexec)
