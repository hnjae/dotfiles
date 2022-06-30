#
# Executes commands at the start of an interactive session.
#

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ] \
  && source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"


# Source Prezto.
# -s: if file exists and is greater than zero
[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ] \
	&& source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

# prompt paradox
# Customize to your needs...
# "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
# "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
# "/usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
source_array=(
	"/usr/share/zsh/plugins/fzf-tab-git/fzf-tab.zsh"
        "/usr/share/zsh/plugins/fzf-tab-bin-git/fzf-tab.zsh"
	"/usr/share/fzf/completion.zsh"
	"/usr/share/fzf/key-bindings.zsh"
	"/usr/local/Cellar/fzf/0.30.0/shell/completion.zsh"
	"/usr/local/Cellar/fzf/0.30.0/shell/key-bindings.zsh"
        # "/usr/share/lf/lfcd.sh"
)
for source_file in ${source_array[@]}; do
	[ -f "$source_file"  ] && source "$source_file"
done

# FASD
# TODO: fasd has been deprecated <2022-06-24, Hyunjae Kim>
type fasd > /dev/null && eval "$(fasd --init auto)"

# Thefuck
type fuck > /dev/null && eval "$(thefuck --alias)"

# auto completion for pip
type pip > /dev/null && eval "$(pip completion --zsh)" && compctl -K _pip_completion pip3

lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    # echo "$tmp"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        # echo "$dir"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
# -f: if file exists and is a regular file
[ -f "${ZDOTDIR:-$HOME}/.p10k.zsh" ] && source "${ZDOTDIR:-$HOME}/.p10k.zsh"

# -r: if file exists and is readable
[ -r "${ZDOTDIR:-$HOME}/zsh-alias.zsh" ] && source "${ZDOTDIR:-$HOME}/zsh-alias.zsh"
[ -r "${ZDOTDIR:-$HOME}/__local_config.zsh" ] && source "${ZDOTDIR:-$HOME}/__local_config.zsh"

if [ type pyenv > /dev/null 2>&1 ]; then
    eval "$(pyenv init -)"
    type pyenv-virtualenv-init > /dev/null \
        && eval "$(pyenv virtualenv-init -)"
fi
