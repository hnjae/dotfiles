if (( ! $+commands[navi] )) || [[ $TERM == "dumb" || $options[zle] != on ]]; then
    return
fi

__CHEATS_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/navi/cheats"

$commands[navi] widget zsh >|"${0:A:h}/_navi.zsh"
source "${0:A:h}/_navi.zsh"

function __navi_select() {
    local term="$1"
    local file

    file="$(
        (
            fd "$term" "$__CHEATS_DIR" -e cheat -t f
        ) |
            sed -e "s|^$__CHEATS_DIR||g" -e "s|\.cheat$||g" |
            fzf --select-1 --exit-0 --preview='bat -l sh --color=always --italic-text=always --paging=never --decorations=never '"$__CHEATS_DIR"'/{}.cheat' |
            awk -v path="$__CHEATS_DIR" -v ext=".cheat" '{print path $0 ext}'
    )"

    echo "$file"
}

function navi-edit() {
    local file
    if [[ $1 != "" ]]; then
        file="$__CHEATS_DIR/$1.cheat"
    else
        file="$(__navi_select ".")"
        [[ $file == "" ]] && return
    fi

    nvim -- "$file"
}

function navi-show() {
    local file
    if [[ -n $1 && -f "$__CHEATS_DIR/$1.cheat" ]]; then
        file="$__CHEATS_DIR/$1.cheat"
    else
        local term
        if [[ $1 != "" ]]; then
            term="$1"
        else
            term="."
        fi

        file="$(__navi_select "$term")"
        [[ $file == "" ]] && return
    fi

    sed -e '/^\$/d' -- "$file" |
        bat -l sh --color=always --decorations=never --paging=never
}

alias -- na="navi"
alias -- ne="navi-edit"
alias -- nsh="navi-show"
