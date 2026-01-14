if (( ! $+commands[wezterm] )); then
    return
fi

local pf # prefix

pf="wm"

alias $pf="wezterm"
alias ${pf}c="wezterm connect"
alias ${pf}s="wezterm ssh"
alias ${pf}l="wezterm cli"
alias ${pf}ll="wezterm cli"

unset pf
