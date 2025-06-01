if (( ! $+commands[bat] )); then
  return
fi

# -F: --quit-if-one-screen
# -L: --no-lessopen
# -R: --RAW-CONTROL-CHARS

export BAT_PAGER="less -iLR"
export BAT_THEME="gruvbox-light"

alias -- c="bat --paging=never --style=plane"
