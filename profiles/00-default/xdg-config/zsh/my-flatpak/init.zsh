# TODO: --user 옵션이 deprecated 된 것 같다?? <2025-05-31>

if (( ! $+commands[flatpak] )); then
    return
fi

alias fl="flatpak --user"
alias flr="flatpak --user run"
alias flx="flatpak --user run"
alias fls="flatpak --user search"
alias fli="flatpak --user install"
alias flu="flatpak --user update"
alias flh="flatpak --help"
alias flps="flatpak ps"
alias flk="flatpak kill"
