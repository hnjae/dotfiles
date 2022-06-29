#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

########################################################################
# Source fallback profile
# -f: file exists and is a regular file.
[ -f /etc/profile ] && source /etc/profile
[ -f "$HOME/.profile" ] && source "$HOME/.profile"

# X11 세션일 경우 xprofile 도 읽어 들임
# SDDM에서 이미 읽은 것 같지만, zsh 에서는 적용이 안된다.
if [ "$XDG_SESSION_TYPE" = "x11" -o "$XDG_SESSION_TYPE" = "X11" ]; then
    [ -f /etc/xprofile ] && source /etc/xprofile
    [ -f /usr/local/etc/xprofile ] && source /usr/local/etc/xprofile
    [ -f "$HOME/.xprofile" ] && source "$HOME/.xprofile"
fi
########################################################################

########
# Browser
########

[[ "$OSTYPE" == darwin* ]] && export BROWSER='open' &&  export OPENER='open'
########
# Editors, PAGER, VISUAL
########
# Config this envvar in .profile

########
# Language
########
[[ -z "$LANG" ]] && export LANG='en_US.UTF-8'

########
# Paths
########
#
# export PATH="$HOME/.local/bin:$PATH"
# # export MANPATH="$HOME/.local/man:$MANPATH"
fpath=("${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions" $fpath)
[ -d /usr/local/share/zsh/site-functions ] \
    && fpath=("/usr/local/share/zsh/site-functions" $fpath)

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )


# Set GNU Tools
if [[ "$OSTYPE" == darwin* ]]; then
    gnu=(
        "/usr/local/opt/gnu-sed/libexec/gnubin"
        "/usr/local/opt/gnu-tar/libexec/gnubin"
        "/usr/local/opt/gnu-which/libexec/gnubin"
        "/usr/local/opt/gnu-indent/libexec/gnubin"
        "/usr/local/opt/grep/libexec/gnubin"
        "/usr/local/opt/coreutils/libexec/gnubin"
    )
    for new_path in ${gnu[@]}; do
        [ -d "$new_path" ] && PATH="$new_path:$PATH"
    done
    type gawk > /dev/null && alias awk=gawk
fi

# Set the list of directories that Zsh searches for programs.
path=(
    "$HOME/.local/bin"
    "${XDG_DATA_HOME:-$HOME/.local/share}/gem/ruby/3.0.0/bin"
    /usr/local/{bin,sbin}
    $path
)

########
# Less
########

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X to enable it.
export LESS='-g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi
