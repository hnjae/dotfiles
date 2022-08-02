# Executes commands at the start of an interactive session.

# -s: if file exists and is greater than zero
# -r: if file exists and is readable
# -f: if file exists and is a regular file

# type starship > /dev/null && eval "$(starship init zsh)"
# "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
# "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
# "/usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
source_array=(
    "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/zprezto/init.zsh"
    "/usr/share/zsh/plugins/fzf-tab-git/fzf-tab.zsh"
    "/usr/share/zsh/plugins/fzf-tab-bin-git/fzf-tab.zsh"
    "/usr/share/fzf/completion.zsh"
    "/usr/share/fzf/key-bindings.zsh"
    "/usr/local/Cellar/fzf/0.30.0/shell/completion.zsh"
    "/usr/local/Cellar/fzf/0.30.0/shell/key-bindings.zsh"
    # "/usr/share/lf/lfcd.sh"
    "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/p10k.zsh"
# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
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

type zoxide > /dev/null && eval "$(zoxide init zsh)"

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

if type pyenv > /dev/null 2>&1; then
    eval "$(pyenv init - zsh)"
    # type pyenv-virtualenv-init > /dev/null \
    #     && eval "$(pyenv virtualenv-init -)"
fi


# -r: if file exists and is readable
[ -r "${ZDOTDIR:-$HOME}/.zalias" ] && source "${ZDOTDIR:-$HOME}/.zalias"
[ -r "${ZDOTDIR:-$HOME}/__local_config.zsh" ] && source "${ZDOTDIR:-$HOME}/__local_config.zsh"


# HISTFILE 은, zprofile, zenvironment 에 있으면 먹질 않음 (2022-07-02)
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/zsh_history"
