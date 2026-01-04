if (( ! ${+PAGER} )); then
    if (( ${+commands[less]} )); then
        export PAGER=less
    else
        export PAGER=more
    fi
fi

if (( ! ${+LESS} )); then
    export LESS='--ignore-case --jump-target=4 --LONG-PROMPT --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'
fi

# -s: file exists and is not empty
if [[ -z "${NO_COLOR}" || "$TERM" != "dumb" || -s "${HOME}/.dir_colors" ]]; then
    local initdircolors="${0:A:h}/_dircolors.zsh"

    if [[ ! -e "$initdircolors" || "$initdircolors" -ot "${HOME}/.dir_colors" ]]; then
        dircolors --sh "${HOME}/.dir_colors" >| "$initdircolors"
        zcompile -UR "$initdircolors"
    fi

    source "$initdircolors"
fi

alias chmod='chmod --preserve-root -v'
alias chown='chown --preserve-root -v'

alias du="du -h"
alias df="df -H"

# cd to XDG directories
alias sxc='cd "${XDG_CONFIG_HOME:-$HOME/.config}"'
alias sxd='cd "${XDG_DATA_HOME:-$HOME/.local/share}"'
alias sxs='cd "${XDG_STATE_HOME:-$HOME/.local/state}"'


if (( ${+commands[nvim]} )); then
    alias vi="nvim"
    alias vimdiff='nvim -d'
else
    alias vi="vim"
    alias nvim="vim"
fi

alias cp="cp -i --preserve=all --reflink=auto"
alias mv="mv -i"
alias j="just"
alias je="just --edit"

alias fmime='file --mime-type --brief --'
alias xmime='xdg-mime query filetype'
alias nfd2nfc-dryrun='convmv -r -f utf8 -t utf8 --nfc .'
alias nfd2nfc-run='convmv -r -f utf8 -t utf8 --nfc --notest .'
alias colorpattern="curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/e50a28ec54188d2413518788de6c6367ffcea4f7/print256colours.sh | bash"
