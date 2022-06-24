#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

################################################################################
# Prezto
################################################################################
#
# Ensure that a non-login, non-interactive shell has a defined environment.
[[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]] \
   && source "${ZDOTDIR:-$HOME}/.zprofile"

################################################################################
# This file is always sourced. Put things that need to be updated frequently

# https://superuser.com/questions/18988/difference-between-a-b-and-export-a-b-in-bash
# uname -r 에서 arch 가 있으면 이라고 한정 지어도 될 것 같다.
################################################################################

# Global
export OPENER=xdg-open

# source "$PYENV_ROOT/completions/pyenv.zsh"

# nvim virtual_env fix
# if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
#   source "${VIRTUAL_ENV}/bin/activate"
# fi
#
# if [ -f "/usr/bin/pyenv" ]; then
# 	export PYENV_ROOT="$HOME/.local/share/pyenv"
# 	eval "$(pyenv init -)"
# 	eval "$(pyenv virtualenv-init -)"
# fi


# alias vi="nvim -u $HOME/.config/nvim/essential.vim"
# export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git --exclude "__pycache__"'
export FZF_DEFAULT_COMMAND='fd --follow --exclude .git --exclude "__pycache__"'

# nnn
[ -r /usr/share/nnn/quitcd/quitcd.bash_zsh ] \
    && source /usr/share/nnn/quitcd/quitcd.bash_zsh

export NNN_BMS='s:~/Sync;t:~/Sync/Study;w:~/Sync/Library/wi;l:~/.local;c:~/.config'
# export NNN_PLUG="p:preview-tui;t:preview-tabbed;i:imgview;f:finder;j:autojump;s:suedit;r:renamer;b:bookmarks;c:rsynccp"
export NNN_PLUG="p:preview-tui;i:imgview;e:-!sudo -E nvim $nnn*"
# # cdpath, diffs, fixname, fzhist, rsynccp, upload
BLK="0B"
CHR="0B"
DIR="04"
EXEC="06"
FILE="00"
MULTIHARDLINK="06"
LINK="06"
MISSING="F7" # Not sure what this is
ORPHAN="09"
FIFO="06"
SOCK="0B"
OTHER="06"
export NNN_FCOLORS="$BLK$CHR$DIR$EXEC$FILE$MULTIHARDLINK$LINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"
# export NNN_TRASH=1
export NNN_FIFO="/tmp/nnn.fifo"
export NNN_OPTS="UdE"
