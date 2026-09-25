if ((!$+commands[direnv])) || [[ -z ${TMUX:-} ]]; then
    return
fi

local initfile="${0:A:h}/_direnv-hook-zsh.zsh"
local sigfile="${initfile}.sig"
local sig="${commands[direnv]:A}"

# Cache invalidation policy:
# - `-ot` catches ordinary in-place direnv updates.
# - `${commands[direnv]:A}` catches Nix upgrades because the real store path changes.

if [[
    ! -s "$initfile" ||
    "$initfile" -ot "${commands[direnv]}" ||
    ! -e "$sigfile" ||
    "$(<"$sigfile")" != "$sig" ]] \
    ; then
    "${commands[direnv]}" hook zsh >|"$initfile" || return 1
    print -r -- "$sig" >|"$sigfile"
    zcompile -UR "$initfile"
fi
source "$initfile" || return 1

if [[ -z ${NO_COLOR} && ${+DIRENV_LOG_FORMAT} -eq 0 ]] export DIRENV_LOG_FORMAT=$'\E[2mdirenv: %s\E[0m'
