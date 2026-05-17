if ((!$+commands[devenv])); then
    return
fi

local initfile="${0:A:h}/_devenv.zsh"
local sigfile="${initfile}.sig"
local sig="${commands[devenv]:A}"

# Cache invalidation policy:
# - `-ot` catches ordinary in-place binary updates.
# - `${commands[devenv]:A}` catches Nix/NixOS upgrades because the real store path changes.
#
# hyperfine --warmup 5 --runs 50, 2026-05-17:
# - hyperfine 1.20.0; zsh 5.9 (x86_64-pc-linux-gnu); devenv 2.1.0 (x86_64-linux)
# - zsh -fc ':'                                      3.7 ms ± 0.8 ms
# - zsh -fc 'source eval-hook.zsh'                  28.1 ms ± 3.3 ms
# - zsh -fc 'source cached-hook.zsh'                 5.6 ms ± 0.9 ms
# - devenv hook zsh >/dev/null                      22.9 ms ± 3.2 ms
# Baseline-adjusted cost: eval hook is about +24.4 ms; cached hook is about +1.9 ms.
if [[
    ! -e "$initfile" ||
    "$initfile" -ot "${commands[devenv]}" ||
    ! -e "$sigfile" ||
    "$(<"$sigfile")" != "$sig" ]] \
    ; then
    $commands[devenv] hook zsh >|"$initfile"
    print -r -- "$sig" >|"$sigfile"
fi

source "$initfile"
