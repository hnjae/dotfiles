if ((!$+commands[navi])) || [[ $TERM == "dumb" || $options[zle] != on ]]; then
    return
fi

local initfile="${0:A:h}/_navi.zsh"
local sigfile="${initfile}.sig"
local sig="${commands[navi]:A}"

autoload -Uz navi-edit __navi_select_enhanced

alias -- ne="navi-edit"

# Cache invalidation policy:
# - `-ot` catches ordinary in-place navi updates.
# - `${commands[navi]:A}` catches Nix/NixOS upgrades because the real store path changes.
#
# hyperfine, 2026-05-17:
# - hyperfine 1.20.0; zsh 5.9 (x86_64-pc-linux-gnu); navi 2.24.0
# - TERM=xterm-256color XDG_CONFIG_HOME=/tmp/navi-bench-config
# - zsh -fic ':'                                      3.5 ms ± 0.8 ms
# - zsh -fic 'source cached-hit.zsh'                  5.9 ms ± 1.1 ms
# - zsh -fic 'source always-regenerate.zsh'           9.5 ms ± 1.1 ms
# - navi widget zsh >/dev/null                        4.1 ms ± 0.6 ms
# - repeat 200 cached hit: 31.9 ms; repeat 200 always regenerate: 828.9 ms
# Repeated runs show the cache check/source path is about 26x cheaper than
# regenerating the widget script each time; single-run measurements are near
# hyperfine noise.
if [[ 
    ! -e "$initfile" ||
    "$initfile" -ot "${commands[navi]}" ||
    ! -e "$sigfile" ||
    "$(<"$sigfile")" != "$sig" ]] \
    ; then
    $commands[navi] widget zsh >|"$initfile" || return 1
    print -r -- "$sig" >|"$sigfile"
    zcompile -UR "$initfile"
fi

source "$initfile"
