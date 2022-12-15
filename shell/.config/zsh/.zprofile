# NOTE:
# Executes commands at login pre-zshrc.
# Only sourced initial login (tty, tmux)


########################################################################
# Source fallback profile
# X11 세션일 경우 xprofile 도 읽어 들임
# -f: file exists and is a regular file.

# [ -f /etc/profile ] && source /etc/profile
# if [ "$XDG_SESSION_TYPE" = "x11" ]; then
#     [ -f /etc/xprofile ] && source /etc/xprofile
#     [ -f /usr/local/etc/xprofile ] && source /usr/local/etc/xprofile
# fi
# [ -f "$HOME/.profile" ] && source "$HOME/.profile"
# if [ "$XDG_SESSION_TYPE" = "x11" ]; then
#     [ -f "$HOME/.xprofile" ] && source "$HOME/.xprofile"
# fi

#######
# Browser
########
[[ "$OSTYPE" == darwin* ]] && export BROWSER='open' &&  export OPENER='open'

########
# Editors, PAGER, VISUAL
########
# Config this environment variable in .profile

########
# Language
########
[ -z "$LANG" ] && export LANG='en_US.UTF-8'

########
# Paths
########
# export PATH="$HOME/.local/bin:$PATH"
# # export MANPATH="$HOME/.local/man:$MANPATH"

fpath_array=(
    "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions"
    "/usr/local/share/zsh/site-functions"
    "/home/linuxbrew/.linuxbrew/share/zsh/site-functions"
    "/usr/share/zsh/site-functions"
)
for dir in ${fpath_array[@]}; do
    [ -d "$dir"  ] && fpath=("$dir" $fpath)
done

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
    "$HOME/.local/mybin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "${XDG_DATA_HOME:-$HOME/.local/share}/gem/ruby/3.0.0/bin"
    /usr/local/{bin,sbin}
    $path
)

# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi
