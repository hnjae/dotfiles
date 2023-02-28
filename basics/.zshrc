# Set up the prompt
if type starship > /dev/null; then
	eval "$(starship init zsh)"
else
	autoload -Uz promptinit
	promptinit
	prompt adam1
fi

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -v

# HISTORY
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/zsh_history"
export HISTSIZE=999999
export SAVEHIST="$HISTSIZE"
# setopt appendhistory
setopt SHARE_HISTORY
setopt hist_ignore_space

# Use modern completion system
autoload -Uz compinit
compinit

# zstyle
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# alias
type fdfind > /dev/null && alias fd="fdfind"
type exa > /dev/null && alias ls="exa"

# smart cd
type zoxide > /dev/null && eval "$(zoxide init zsh)"

# fpath
fpath_array=(
    "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions"
    "/usr/local/share/zsh/site-functions"
    "/usr/share/zsh/site-functions"
)
for dir in ${fpath_array[@]}; do
    [ -d "$dir"  ] && fpath=("$dir" $fpath)
done

# source
source_array=(
    # Arch
    "/usr/share/skim/completion.zsh"
    "/usr/share/skim/key-bindings.zsh"

    # Fedora
    "/usr/share/fzf/shell/key-bindings.zsh"

    # Debian
    "/usr/share/doc/fzf/examples/key-bindings.zsh"
)
for source_file in ${source_array[@]}; do
        [ -f "$source_file"  ] && source "$source_file"
done

# linuxbrew
[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ] \
	&& eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
