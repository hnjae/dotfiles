# Executes commands at the start of an interactive session.



# -s: if file exists and is greater than zero
# -r: if file exists and is readable
# -f: if file exists and is a regular file

# "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
# "/usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"

if type starship > /dev/null; then
    eval "$(starship init zsh)"

    # source_file="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    # source_file="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/p10k.zsh"
    # [ -f "$source_file" ] && source "$source_file"
    # To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
fi

source_array=(
    "${ZPREZTODIR:-${XDG_DATA_HOME:-$HOME/.local/share}/zprezto}/init.zsh"

    # Arch
    # "/usr/share/fzf/completion.zsh"
    # "/usr/share/fzf/key-bindings.zsh"
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

source_array=(
    # Arch (?)
    # "/usr/share/fzf/completion.zsh"
    # "/usr/share/fzf/key-bindings.zsh"
    # "/usr/share/doc/find-the-command/ftc.zsh"

    # Fedora
    # "/usr/share/doc/git/contrib/completion/git-completion.zsh"
)


# FASD
# NOTE: fasd has been deprecated <2022-06-24, Hyunjae Kim>
# type fasd > /dev/null && eval "$(fasd --init auto)"

# Thefuck (2022-08-03: It make shell slow)
# type fuck > /dev/null && eval "$(thefuck --alias)"

# auto completion for pip (2022-08-03: It make shell slow)
# type pip3 > /dev/null && eval "$(pip3 completion --zsh)" && compctl -K _pip_completion pip3

# smart cd
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

# # if type pyenv > /dev/null 2>&1; then
#     # eval "$(pyenv init - zsh)"
#     # type pyenv-virtualenv-init > /dev/null \
#     #     && eval "$(pyenv virtualenv-init -)"
# # fi

[ -f "${ZDOTDIR:-$HOME}/.zalias" ] && source "${ZDOTDIR:-$HOME}/.zalias"
[ -f "${ZDOTDIR:-$HOME}/__local_config.zsh" ] && source "${ZDOTDIR:-$HOME}/__local_config.zsh"


# HISTFILE 은, zprofile, zenvironment 에 있으면 먹질 않음 (2022-07-02)
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/zsh_history"
export HISTSIZE=999999
export SAVEHIST="$HISTSIZE"
setopt appendhistory
setopt SHARE_HISTORY
setopt hist_ignore_space

# add-zsh-hook -Uz chpwd osc7
# Change terminal title
case "$TERM" in (foot|rxvt|rxvt-*|st|st-*|*xterm*|(dt|k|E)term)
    local term_title () { print -n "\e]0;${(j: :q)@}\a" }
    precmd () {
      local DIR="$(print -P '[%c]%#')"
      term_title "$DIR" "zsh"
    }
    preexec () {
      local DIR="$(print -P '[%c]%#')"
      local CMD="${(j:\n:)${(f)1}}"
      term_title "$DIR" "$CMD"
    }
  ;;
esac
