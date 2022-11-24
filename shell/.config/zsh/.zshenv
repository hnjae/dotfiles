# NOTE
# Defines environment variables.
# Sourced before .zprofile, .zshrc
# This file is always sourced. Put things that need to be updated frequently

################################################################################
# Prezto
################################################################################

# Ensure that a non-login, non-interactive shell has a defined environment.
[[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]] \
   && source "${ZDOTDIR:-$HOME}/.zprofile"

################################################################################

# https://superuser.com/questions/18988/difference-between-a-b-and-export-a-b-in-bash
# uname -r 에서 arch 가 있으면 이라고 한정 지어도 될 것 같다.
################################################################################

export ZPREZTODIR="${XDG_DATA_HOME:-$HOME/.local/share}/zprezto"

export PYENV_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}/pyenv"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# source "$PYENV_ROOT/completions/pyenv.zsh"

# nvim virtual_env fix
# if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
#   source "${VIRTUAL_ENV}/bin/activate"
# fi

export FZF_DEFAULT_COMMAND='fd --follow --exclude .git --exclude "__pycache__"'

# nnn
[ -r /usr/share/nnn/quitcd/quitcd.bash_zsh ] \
    && source /usr/share/nnn/quitcd/quitcd.bash_zsh

export NNN_BMS='s:~/Sync;t:~/Sync/Study;w:~/Sync/Library/wi;l:~/.local;c:~/.config'
export NNN_PLUG="p:preview-tui;i:imgview;e:-!sudo -E nvim $nnn*"
# export NNN_TRASH=1
export NNN_FIFO="/tmp/nnn.fifo"
export NNN_TMPFILE='/tmp/.nnn_lastd'
export NNN_OPTS="E"

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X to enable it.
export LESS='-g -i -M -R -S -w -X -z-4'


export BAT_THEME="base16"
