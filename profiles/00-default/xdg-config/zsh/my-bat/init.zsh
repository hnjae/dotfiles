if (( ! $+commands[bat] )); then
    return
fi

# -F: --quit-if-one-screen
# -L: --no-lessopen
# -R: --RAW-CONTROL-CHARS

export BAT_PAGER="less -iLR"

if [[ $TERM_PROGRAM == "WezTerm" ]]; then
    export BAT_THEME="base16"
elif [[ $TERM_PROGRAM == "ghostty" ]]; then
    export BAT_THEME="base16-256"
else
    export BAT_THEME="ansi"
fi

alias -- c="bat --paging=never --style=plane"
