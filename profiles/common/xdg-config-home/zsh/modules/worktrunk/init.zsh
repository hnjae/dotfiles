if (( !$+commands[wt] )); then
    return
fi

local initfile="${0:A:h}/_wt.zsh"
local sigfile="${initfile}.sig"
local sig="${commands[wt]:A}"

# Cache invalidation policy:
# - `-ot` catches ordinary in-place binary updates.
# - `${commands[wt]:A}` catches Nix/NixOS upgrades because the real store path changes.
#
# `wt config shell init zsh` spawns the binary and prints its shell integration
# (a `wt` wrapper that cds the parent shell, plus lazy completions), which costs
# ~65 ms per shell on 2026-11-14. Generating once and sourcing the cached file
# keeps that off the startup path.
#
# This module must be loaded after compinit: the generated script registers its
# completion via `compdef` and silently skips it when compinit has not run yet.
if [[
    ! -s "$initfile" ||
    "$initfile" -ot "${commands[wt]}" ||
    ! -e "$sigfile" ||
    "$(<"$sigfile")" != "$sig" ]] \
    ; then
    "${commands[wt]}" config shell init zsh >|"$initfile" || return 1
    print -r -- "$sig" >|"$sigfile"
    zcompile -UR "$initfile"
fi
source "$initfile"
