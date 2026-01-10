local pf # prefix
pf="zw"

alias $pf="zimfw"
alias ${pf}b="zimfw build"
alias ${pf}h="zimfw --help"
alias ${pf}c="zimfw clean && exec zsh"
alias ${pf}i="zimfw install -v && exec zsh"
alias ${pf}r="zimfw reinstall -v && exec zsh"
alias ${pf}u="zimfw update -v && exec zsh"
# alias ${pf}ug="zimfw upgrade && exec zsh"

unset pf
